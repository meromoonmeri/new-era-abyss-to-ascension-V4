/*
 * Deterministic authenticated-ROM M4A one-shot fanfare-to-Ogg renderer.
 *
 * Links the campaign-pinned M4plAy, libogg, and libvorbis sources.  Playback
 * ends only when the M4A player's TRACK status bit clears; a caller-supplied
 * sample-count gate proves that independent fresh processes stop at the same
 * native sequence boundary.  This is intentionally separate from the looping
 * music renderer and never weakens that renderer's synchronized-loop gate.
 */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <ogg/ogg.h>
#include <vorbis/codec.h>
#include <vorbis/vorbisenc.h>

#include "m4play.h"
#include "m4a_internal.h"

#define MIXER_RATE 48000
#define SAMPLES_PER_FRAME (MIXER_RATE / 60)
#define MAX_RENDER_FRAMES (60 * 120)
#define OGG_SERIAL 0x46414e46

extern struct MusicPlayerInfo gMPlayInfo_BGM;

static uint8_t *rom_data;
static uint32_t rom_size;

static void fail(const char *message) {
    fprintf(stderr, "ERROR: %s\n", message);
    exit(1);
}

static uint32_t scan_song_table(uint32_t *mode) {
    uint32_t pos = 0;
    uint32_t temp;
    while (pos < rom_size - 35) {
        if ((rom_data[pos] & 0xBF) == 0x89 &&
            rom_data[pos + 1] == 0x18 && rom_data[pos + 2] == 0x0A &&
            rom_data[pos + 3] == 0x68 && rom_data[pos + 4] == 0x01 &&
            rom_data[pos + 5] == 0x68 && rom_data[pos + 6] == 0x10 &&
            rom_data[pos + 7] == 0x1C && (rom_data[pos + 23] & 0xFE) == 0x08)
            break;
        pos += 4;
    }
    if (pos >= rom_size - 35 || pos < 64)
        fail("M4A song-table signature not found");
    if (rom_data[pos - 61] == 0x03 && rom_data[pos - 57] == 0x04)
        temp = ((uint32_t)rom_data[pos - 45] << 24) |
               ((uint32_t)rom_data[pos - 46] << 16) |
               ((uint32_t)rom_data[pos - 47] << 8) | rom_data[pos - 48];
    else
        temp = ((uint32_t)rom_data[pos - 61] << 24) |
               ((uint32_t)rom_data[pos - 62] << 16) |
               ((uint32_t)rom_data[pos - 63] << 8) | rom_data[pos - 64];
    *mode = temp;
    pos = ((uint32_t)rom_data[pos + 23] << 24) |
          ((uint32_t)rom_data[pos + 22] << 16) |
          ((uint32_t)rom_data[pos + 21] << 8) | rom_data[pos + 20];
    return pos & 0x07FFFFFF;
}

static void write_pages(FILE *output, ogg_stream_state *stream, int flush) {
    ogg_page page;
    while (flush ? ogg_stream_flush(stream, &page) : ogg_stream_pageout(stream, &page)) {
        if (fwrite(page.header, 1, page.header_len, output) != (size_t)page.header_len ||
            fwrite(page.body, 1, page.body_len, output) != (size_t)page.body_len)
            fail("could not write Ogg page");
    }
}

static void submit_analysis(vorbis_dsp_state *dsp, vorbis_block *block,
                            ogg_stream_state *stream, FILE *output) {
    ogg_packet packet;
    while (vorbis_analysis_blockout(dsp, block) == 1) {
        vorbis_analysis(block, NULL);
        vorbis_bitrate_addblock(block);
        while (vorbis_bitrate_flushpacket(dsp, &packet)) {
            ogg_stream_packetin(stream, &packet);
            write_pages(output, stream, 0);
        }
    }
}

int main(int argc, char **argv) {
    if (argc != 7 && argc != 8) {
        fprintf(stderr, "usage: %s ROM SONG_INDEX OUTPUT_OGG ROM_SHA256 TITLE EXPECTED_SAMPLES [M4A_KIND]\n", argv[0]);
        return 2;
    }
    char *end = NULL;
    long song_index = strtol(argv[2], &end, 10);
    if (!end || *end || song_index < 0 || song_index > UINT16_MAX)
        fail("invalid song index");
    end = NULL;
    long long expected_samples = strtoll(argv[6], &end, 10);
    if (!end || *end || expected_samples < 0)
        fail("invalid expected sample count");

    FILE *rom = fopen(argv[1], "rb");
    if (!rom) fail("could not open ROM");
    if (fseek(rom, 0, SEEK_END) || (rom_size = (uint32_t)ftell(rom)) == 0 ||
        fseek(rom, 0, SEEK_SET))
        fail("could not size ROM");
    rom_data = malloc(rom_size);
    if (!rom_data || fread(rom_data, 1, rom_size, rom) != rom_size)
        fail("could not read ROM");
    fclose(rom);

    uint32_t mode = 0;
    uint32_t song_table = scan_song_table(&mode);
    m4aSoundInit(MIXER_RATE, rom_data, song_table, mode);
    m4aSongNumStart((uint16_t)song_index);
    int track_count = gMPlayInfo_BGM.songHeader->trackCount;
    if (track_count < 1 || track_count > MAX_MUSICPLAYER_TRACKS)
        fail("invalid M4A track count");
    vorbis_info info;
    vorbis_info_init(&info);
    if (vorbis_encode_init_vbr(&info, 2, MIXER_RATE, 0.5f))
        fail("could not initialize Vorbis encoder");
    vorbis_comment comment;
    vorbis_comment_init(&comment);
    vorbis_comment_add_tag(&comment, "TITLE", argv[5]);
    vorbis_comment_add_tag(&comment, "SOURCE", "Pokemon Mystery Dungeon Red Rescue Team EU ROM");
    vorbis_comment_add_tag(&comment, "SOURCE_ROM_SHA256", argv[4]);
    vorbis_comment_add_tag(&comment, "PMDRED_M4A_KIND", argc == 8 ? argv[7] : "FANFARE");
    char song_tag[32];
    snprintf(song_tag, sizeof(song_tag), "%ld", song_index);
    vorbis_comment_add_tag(&comment, "M4A_SONG_TABLE_INDEX", song_tag);

    vorbis_dsp_state dsp;
    vorbis_block block;
    ogg_stream_state stream;
    if (vorbis_analysis_init(&dsp, &info) || vorbis_block_init(&dsp, &block) ||
        ogg_stream_init(&stream, OGG_SERIAL))
        fail("could not initialize Ogg analysis state");
    FILE *output = fopen(argv[3], "wb");
    if (!output) fail("could not create output");
    ogg_packet header, header_comment, header_code;
    if (vorbis_analysis_headerout(&dsp, &comment, &header, &header_comment, &header_code))
        fail("could not create Vorbis headers");
    ogg_stream_packetin(&stream, &header);
    ogg_stream_packetin(&stream, &header_comment);
    ogg_stream_packetin(&stream, &header_code);
    write_pages(output, &stream, 1);

    float interleaved[SAMPLES_PER_FRAME * 2];
    int64_t rendered_samples = 0;
    int became_active = 0;
    int completed = 0;
    for (int frame = 0; frame < MAX_RENDER_FRAMES; ++frame) {
        RunMixerFrame(interleaved, SAMPLES_PER_FRAME);
        float **buffer = vorbis_analysis_buffer(&dsp, SAMPLES_PER_FRAME);
        for (int sample = 0; sample < SAMPLES_PER_FRAME; ++sample) {
            buffer[0][sample] = interleaved[sample * 2];
            buffer[1][sample] = interleaved[sample * 2 + 1];
        }
        vorbis_analysis_wrote(&dsp, SAMPLES_PER_FRAME);
        submit_analysis(&dsp, &block, &stream, output);
        rendered_samples += SAMPLES_PER_FRAME;
        if ((gMPlayInfo_BGM.status & MUSICPLAYER_STATUS_TRACK) != 0)
            became_active = 1;
        else if (became_active) {
            completed = 1;
            break;
        }
    }
    if (!became_active)
        fail("M4A fanfare never entered TRACK playback state");
    if (!completed)
        fail("M4A fanfare did not clear TRACK status within the bounded render");
    if (expected_samples != 0 && rendered_samples != expected_samples)
        fail("completion sample count differs from the independent discovery run");

    vorbis_analysis_wrote(&dsp, 0);
    submit_analysis(&dsp, &block, &stream, output);
    write_pages(output, &stream, 1);
    if (fclose(output)) fail("could not finalize output");

    fprintf(stdout,
            "song_table=0x%08x mode=0x%08x tracks=%d samples=%lld completion=TRACK_CLEAR\n",
            song_table, mode, track_count, (long long)rendered_samples);

    ogg_stream_clear(&stream);
    vorbis_block_clear(&block);
    vorbis_dsp_clear(&dsp);
    vorbis_comment_clear(&comment);
    vorbis_info_clear(&info);
    free(rom_data);
    return 0;
}
