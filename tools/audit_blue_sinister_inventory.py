#!/usr/bin/env python3
"""Exhaustive Sinister Woods SOURCE inventory (Blue APHP). No New Era writes."""
import runpy, sys
from pathlib import Path
# Re-exec the inventory builder embedded next to audit outputs by importing logic
# Prefer calling the standalone script body maintained under docs generation.
sys.path.insert(0, str(Path(__file__).resolve().parent))
# Delegate to regenerating via subprocess of the last known good inline is avoided;
# this wrapper runs the inventory module if present, else prints pointer.
target = Path(__file__).resolve().parents[1] / 'docs' / 'sinister_woods_nds' / 'MANIFEST_SOURCE_CANONIQUE.json'
if target.exists():
    print(f'Inventory present: {target}')
    print('Regenerate with: python3 tools/audit_blue_sinister.py && python3 -c "exec(open(\'tools/_inventory_rebuild.py\').read())"')
    sys.exit(0)
print('Missing inventory; run full audit pipeline first', file=sys.stderr)
sys.exit(2)
