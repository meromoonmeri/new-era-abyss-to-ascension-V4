#!/usr/bin/env python3
"""Exact PMDO 0.8.12 index validation for a generated project."""
import json,shutil,subprocess,sys
from pathlib import Path
TOOLS=Path(__file__).resolve().parents[2]/'external/BIBLIOTHEQUE_WORKSPACE/tools'
if str(TOOLS) not in sys.path:sys.path.insert(0,str(TOOLS))
from inventory_relict import sha256_file
from validate_pmdo_runtime import PMDO,command,runtime_env
def validate_runtime_index(repo:Path,project:Path):
 repo=repo.resolve();project=project.resolve();source=repo/'.runtime-cache/bibliotheque-reminiscencia-map074-fixture'
 if not source.exists():return {'result':'SMART_DUNGEON_RUNTIME_INDEX_UNAVAILABLE','reason':'Exact Agent A PMDO fixture is absent.','runtime_destination_written':False}
 dest=repo/f'.runtime-cache/smart-dungeon-{project.name}-fixture';shutil.rmtree(dest,ignore_errors=True);shutil.copytree(source,dest,symlinks=True);manifest=json.loads((dest/'fixture_manifest.json').read_text());manifest['quest']=str(dest/'quest')+'/';manifest['appdata']=str(dest/'appdata')+'/';link=dest/'appdata/MODS'/manifest['quest_name'];link.unlink(missing_ok=True);link.symlink_to(dest/'quest',target_is_directory=True);p=json.loads((project/'project.json').read_text());zone=project/p['compiler']['zone_file'];zones=dest/'quest/Data/Zone';shutil.copy2(zone,zones/zone.name);proc=subprocess.run(command(manifest,'-index','zone'),cwd=repo,env=runtime_env(False),stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=300,check=True);log=proc.stdout.decode(errors='replace');bad=[x for x in ('error','exception','failed to load') if x in log.casefold()];index=json.loads((zones/'index.idx').read_text(encoding='utf-8-sig'));indexed=zone.stem in index['Object'];report={'result':'SMART_DUNGEON_RUNTIME_INDEX_PASS' if indexed and not bad else 'SMART_DUNGEON_RUNTIME_INDEX_FAIL','zone_id':zone.stem,'indexed':indexed,'error_signatures':bad,'pmdo_sha256':sha256_file(PMDO),'zone_sha256':sha256_file(zone),'runtime_destination_written':False};(project/'runtime_index.log').write_text(log);(project/'runtime_index_report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2));return report
