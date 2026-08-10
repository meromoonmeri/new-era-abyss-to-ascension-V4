#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sseq2midi.py — convertit les séquences SDAT/SSEQ de PMD Blue Rescue Team (NDS) en MIDI.

Usage :
    python3 tools/sseq2midi.py <sound.sbin> <index_seq> [index_seq ...] [--out dossier] [--loops N]

SDAT parsé via ndspy (soundArchive.SDAT). Chaque séquence est un SSEQ, bytecode
NDS (opcodes documentés par ndspy.soundSequence + fincs/midi2sseq) :

  - 0x00-0x7F : NOTE  (hauteur = opcode ; vélocité+flag ; durée VL = GATE)
  - 0x80      : REST  (durée VL — seule commande qui fait avancer le temps
                        en mode notewait OFF, confirmé par la structure
                        note+rest explicite des séquences Blue)
  - 0x81      : INSTRUMENT (bankID, instrumentID) -> program change
  - 0x93      : BEGIN TRACK (numéro, offset 3 octets) — déclaration
  - 0x94      : JUMP (dest 3 octets) — saut simple
  - 0x95      : CALL (dest 3 octets) / 0xFD RETURN
  - 0xD4      : BEGIN LOOP (count 1 octet ; 0 = infini) / 0xFC END LOOP
  - 0xC0 PAN, 0xC1 VOLUME PISTE, 0xC2/C2x VOLUME GLOBAL, 0xD5 EXPRESSION
  - 0xE1      : TEMPO (u16 BPM) — global
  - 0xFF      : END TRACK ; 0xFE DEFINE TRACKS

Temps : 1 noire = 48 ticks SSEQ (référence fincs) ; tempo = BPM.
Boucles : chaque boucle est étendue `loops` fois (défaut 2) pour un MIDI audible
sans mécanisme de boucle. Les commandes ignorées (vibrato, ADSR, variables,
random, if) n'affectent pas le timing ni les notes.
"""
import argparse
import os
import struct

import ndspy.soundArchive as sa

PPQ = 48


def read_vl(data, pos):
    val = 0
    while True:
        b = data[pos]
        pos += 1
        val = (val << 7) | (b & 0x7F)
        if not (b & 0x80):
            break
    return val, pos


class TrackPlayer:
    def __init__(self, data, channel, loops=2, tempo_cb=None):
        self.data = data
        self.channel = channel
        self.loops = loops
        self.tempo_cb = tempo_cb
        self.events = []
        self.time = 0
        self.mono = False
        self.notewait_off = True   # séquences Blue : <poly> -> notes sans avance
        self.last_note = None

    def emit(self, tick, kind, *args):
        self.events.append((tick, kind, args))

    def run(self, start):
        pc = start
        callstack = []
        loopstack = []   # (loop_start_pc, remaining_passes)
        backward_jumps = 0
        guard = 0
        MAX = 4_000_000
        TICKCAP = 1_500_000
        while guard < MAX:
            guard += 1
            if self.time > TICKCAP:
                break
            if pc >= len(self.data):
                break
            op = self.data[pc]; pc += 1
            if op <= 0x7F:
                velflag = self.data[pc]; pc += 1
                dur, pc = read_vl(self.data, pc)
                vel = velflag & 0x7F
                if self.mono and self.last_note is not None:
                    self.emit(self.time, 'note_off', self.last_note)
                    self.last_note = None
                self.emit(self.time, 'note_on', op, vel)
                self.emit(self.time + dur, 'note_off', op)
                self.last_note = op
                if not self.notewait_off:
                    self.time += dur
            elif op == 0x80:
                dur, pc = read_vl(self.data, pc)
                self.time += dur
            elif op == 0x81:
                bank = self.data[pc]; pc += 1
                inst = self.data[pc]; pc += 1
                self.emit(self.time, 'bank', bank)
                self.emit(self.time, 'pc', inst)
            elif op == 0x93:
                pc += 4
            elif op == 0x94:
                dest = int.from_bytes(self.data[pc:pc+3], 'little')
                if dest < pc + 3:
                    # saut arrière = point de boucle BGM (la séquence boucle) :
                    # on arrête la passe linéaire après `loops` boucles.
                    backward_jumps += 1
                    if backward_jumps >= self.loops:
                        break
                pc = dest
            elif op == 0x95:
                dest = int.from_bytes(self.data[pc:pc+3], 'little')
                callstack.append(pc + 3)
                pc = dest
            elif op == 0xFD:
                if callstack:
                    pc = callstack.pop()
                else:
                    break
            elif op == 0xD4:
                count = self.data[pc]; pc += 1
                # count 0 = infini ; sinon nombre de passages souhaités.
                # On force toujours `loops` passages pour le MIDI.
                loopstack.append((pc, self.loops))
            elif op == 0xFC:
                if loopstack:
                    s, rem = loopstack[-1]
                    if rem > 1:
                        loopstack[-1] = (s, rem - 1)
                        pc = s
                    else:
                        loopstack.pop()
            elif op == 0xC0:
                self.emit(self.time, 'cc', 10, self.data[pc]); pc += 1
            elif op == 0xC1:
                self.emit(self.time, 'cc', 7, self.data[pc]); pc += 1
            elif op in (0xC2, 0xD5):
                self.emit(self.time, 'cc', 11, self.data[pc]); pc += 1
            elif op == 0xC7:
                self.mono = bool(self.data[pc]); pc += 1
                self.notewait_off = not self.mono
            elif op == 0xE1:
                bpm = struct.unpack_from('<H', self.data, pc)[0]
                pc += 2
                if self.tempo_cb:
                    self.tempo_cb(bpm)
            elif op == 0xFE:
                pc += 2
            elif op == 0xFF:
                break
            else:
                # commandes sans impact MIDI (vibrato, ADSR, variables...) :
                # longueurs d'opérandes connues pour ne pas dériver.
                known = {0xC3: 1, 0xC4: 2, 0xC5: 1, 0xC6: 1, 0xC8: 1, 0xC9: 1,
                         0xCA: 1, 0xCB: 1, 0xCC: 1, 0xCD: 1, 0xCE: 1, 0xCF: 1,
                         0xD0: 1, 0xD1: 1, 0xD2: 1, 0xD3: 1, 0xD6: 1,
                         0xE0: 1, 0xE3: 2, 0xA0: 2, 0xA1: 1, 0xA2: 2,
                         0xB0: 2, 0xB1: 2, 0xB2: 2, 0xB3: 2, 0xB4: 2,
                         0xB5: 2, 0xB6: 2, 0xB7: 2, 0xB8: 2, 0xB9: 2,
                         0xBA: 2, 0xBB: 2, 0xBC: 2, 0xBD: 2}
                pc += known.get(op, 1)
        return self.events, self.time


def vlq(n):
    out = [n & 0x7F]
    n >>= 7
    while n:
        out.append((n & 0x7F) | 0x80)
        n >>= 7
    return bytes(reversed(out))


def write_midi(seq_events, path):
    tracks = sorted(seq_events, key=lambda t: t[0])
    chunks = []
    for ch, evs in tracks:
        evs = sorted(evs, key=lambda e: (e[0], 1 if e[1] == 'note_on' else 0))
        data = bytearray()
        last = 0
        for tick, kind, args in evs:
            delta = tick - last
            last = tick
            data += vlq(delta)
            if kind == 'note_on':
                data += bytes([0x90 | ch, args[0] & 0x7F, args[1] & 0x7F])
            elif kind == 'note_off':
                data += bytes([0x80 | ch, args[0] & 0x7F, 0x40])
            elif kind == 'pc':
                data += bytes([0xC0 | ch, args[0] & 0x7F])
            elif kind == 'bank':
                data += bytes([0xB0 | ch, 0, args[0] & 0x7F])
            elif kind == 'cc':
                data += bytes([0xB0 | ch, args[0] & 0x7F, args[1] & 0x7F])
        data += vlq(0) + bytes([0xFF, 0x2F, 0x00])
        chunks.append(bytes(data))

    tempos = []
    for ch, evs in tracks:
        for tick, kind, args in evs:
            if kind == 'tempo':
                tempos.append((tick, args[0]))
    if tempos:
        data = bytearray()
        last = 0
        for tick, bpm in sorted(tempos, key=lambda t: t[0]):
            delta = tick - last
            last = tick
            data += vlq(delta) + bytes([0xFF, 0x51, 0x03]) + int(60_000_000 / bpm).to_bytes(3, 'big')
        data += vlq(0) + bytes([0xFF, 0x2F, 0x00])
        chunks.insert(0, bytes(data))

    out = bytearray()
    out += b'MThd' + struct.pack('>IHHH', 6, 1, len(chunks), PPQ)
    for c in chunks:
        out += b'MTrk' + struct.pack('>I', len(c)) + c
    with open(path, 'wb') as f:
        f.write(out)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('sbin')
    ap.add_argument('indexes', type=int, nargs='+')
    ap.add_argument('--out', default='.')
    ap.add_argument('--loops', type=int, default=2)
    args = ap.parse_args()

    sdat = sa.SDAT.fromFile(args.sbin)
    os.makedirs(args.out, exist_ok=True)
    for idx in args.indexes:
        name, sseq = sdat.sequences[idx]
        if sseq is None:
            print(f'[{idx}] absente')
            continue
        data = sseq.eventsData
        # En-tête : 0xFE (define tracks) + 2 octets (usage mask), puis la table
        # 0x93 (numéro, offset 3 octets) — strictement jusqu'au 1er octet != 0x93.
        pos = 0
        if data[pos] == 0xFE:
            pos += 3
        tracks = {}
        while data[pos] == 0x93:
            num = data[pos + 1]
            off = int.from_bytes(data[pos + 2:pos + 5], 'little')
            tracks[num] = off
            pos += 5
        tracks[0] = pos  # piste principale : commence après la table
        print(f'[{idx}] {name} : {len(tracks)} pistes {sorted(tracks)}')
        tempos = []
        def tempo_cb(bpm):
            if not tempos or tempos[0] != bpm:
                tempos.append(bpm)
        all_events = []
        for num, off in sorted(tracks.items()):
            tp = TrackPlayer(data, num % 16, loops=args.loops, tempo_cb=tempo_cb)
            evs, ticks = tp.run(off)
            if tempos:
                dur_s = ticks / PPQ / (tempos[0] / 60)
            else:
                dur_s = 0
            print(f'    piste {num}: {len(evs)} événements, {ticks} ticks (~{dur_s:.1f}s à {tempos[0] if tempos else "?"} BPM)')
            all_events.append((num, evs))
        if tempos:
            for ch, evs in all_events:
                evs.append((0, 'tempo', (tempos[0],)))
        safe = name.replace('/', '_')
        out_path = os.path.join(args.out, f'{idx:03d}_{safe}.mid')
        write_midi(all_events, out_path)
        print(f'    -> {out_path}')


if __name__ == '__main__':
    main()
