# Authenticated EU post-Tiny-Woods route

## Result

`PASS — scoped EU-ROM route correction`

The exact 33,554,432-byte European ROM authenticates the route after the Tiny
Woods rescue as:

```text
d01p02:g1
→ d01p01:g3
→ regional map-script 9:g16, which selects b01p00a (basic Pikachu base)
→ regional map-script 229:g2, adapted with the French s02_fre title Ground
→ SET_RESCUE_CONQUERED(Tiny Woods)
→ SCENARIO_MAIN = 3,0
→ EVENT_DIVIDE
```

This supersedes the earlier unscoped assumption
`b01p01a:g17 → t00p01:g2`. That assumption mixed three distinct namespaces:
stable graphical asset IDs, source-region technical declarations, and EU
regional map-script IDs.

## Evidence

`eu_post_route_graph.json` records the complete scoped evidence:

- the unique ten-command EU `EVENT_M01E01A_L003` sequence at `0x08286DA0`;
- its authoritative group-16 call for regional map-script 9;
- all six EU rescue-base group-16 scripts, **258 commands**, and **78**
  five-language/French text blocks;
- exact typed-sector and entity-metadata equality between EU group 16 and the
  technical source's group-17 declaration;
- the rescue-base station's explicit `SELECT_MAP(9)`, identifying promoted
  Ground `b01p00a`, not construction Ground `b01p01a`;
- the directly decoded ten-command regional title map-script 229 group 2,
  including music ID 46, 60-frame lead-in, 480-frame hold, and 30-frame fade;
- the French PMDO localization adaptation to promoted Ground `s02_fre`.

The EU title group is decoded directly. The current source-region technical
declaration has no corresponding group 2, so this report deliberately claims
no fictitious source equality there.

## Reproduce

```bash
python3 tools/audit_pmdred_eu_tiny_woods_post_route.py \
  .runtime-cache/downloads/pmdred-eu.gba \
  --pret-root .runtime-cache/pmd-red-reference \
  --report docs/pmdred_eu/playable/tiny_woods/post_route/eu_post_route_graph.json
```

Required identities:

- EU ROM SHA-256: `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`
- technical reference commit: `bf0092d0e34fd8e49b859a0b5f96f00740faa42d`

The ROM is content authority. `pret/pmd-red` is used only for typed declaration
and semantic alignment.
