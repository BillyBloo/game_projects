extends Node

var chunks = {}

var fog_points = {}

func set_fog_at_point(pos,val):
	var v = [Vector2(0,0),Vector2(1,0),Vector2(0,1),Vector2(1,1)]
	var n = ["tl", "tr", "bl", "br"]
	for i in 4:
		chunks[pos-v[i]].set_fog(n[i],val)
