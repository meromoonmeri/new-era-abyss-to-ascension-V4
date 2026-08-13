#!/usr/bin/env python3
"""Serializable domain model for the procedural level-designer."""
from __future__ import annotations
from dataclasses import asdict,dataclass,field
from typing import Any

@dataclass
class AssetProfile:
 asset_id:str;source_file:str;kind:str;tile_size:int=0;sample_count:int=0
 dominant_rgb:list[int]=field(default_factory=lambda:[0,0,0]);mean_luma:float=0.0
 mean_saturation:float=0.0;alpha_coverage:float=1.0;edge_density:float=0.0
 detail_score:float=0.0;symmetry_score:float=0.0;usage_blocked_ratio:float|None=None
 role_scores:dict[str,float]=field(default_factory=dict);tags:list[str]=field(default_factory=list)
 rarity:float=0.5;cluster_id:str="";compatible:list[dict[str,Any]]=field(default_factory=list)
 confidence:float=0.0;overridden:bool=False
 def to_dict(self):return asdict(self)

@dataclass
class DesignBrief:
 name:str;slug:str;intent:str;floors:int=20;difficulty:str="normal";boss:bool=False
 mini_bosses:int=0;relays:int=0;seed:int=0;theme_tokens:list[str]=field(default_factory=list)
 mood_start:str="lisible";mood_end:str="intense";topology_start:str="balanced"
 topology_end:str="complex";water_policy:str="auto";decoration_bias:float=0.5
 danger_bias:float=0.5;constraints:list[str]=field(default_factory=list)
 requested_specials:list[dict[str,Any]]=field(default_factory=list)
 def to_dict(self):return asdict(self)

@dataclass
class Room:
 room_id:int;kind:str;x:int;y:int;width:int;height:int;cells:list[list[int]]
 importance:float=0.0;locked:bool=False;tags:list[str]=field(default_factory=list)
 def to_dict(self):return asdict(self)

@dataclass
class FloorPlan:
 floor:int;seed:int;width:int;height:int;archetype:str;phase:str;special:str|None
 subtheme:str;rooms:list[Room];edges:list[list[int]];tiles:list[str];entrance:list[int]
 exit:list[int];points_of_interest:list[dict[str,Any]]=field(default_factory=list)
 decorations:list[dict[str,Any]]=field(default_factory=list);quality:dict[str,Any]=field(default_factory=dict)
 repair_log:list[dict[str,Any]]=field(default_factory=list);locked_regions:list[dict[str,Any]]=field(default_factory=list)
 def idx(self,x,y):return y*self.width+x
 def get(self,x,y):return self.tiles[self.idx(x,y)]
 def set(self,x,y,v):self.tiles[self.idx(x,y)]=v
 def to_dict(self):
  d=asdict(self);return d

@dataclass
class DungeonPlan:
 schema_version:str;brief:DesignBrief;asset_cluster:str;asset_selection:dict[str,Any]
 progression:list[dict[str,Any]];floors:list[FloorPlan];quality_summary:dict[str,Any]
 compiler:dict[str,Any]=field(default_factory=dict)
 def to_dict(self):return asdict(self)
