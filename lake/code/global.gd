extends Node

var lake_points : PackedVector2Array 
var path_points : PackedVector2Array 

var seed = int("tutorial")

var player : Node2D

func _ready() -> void:
	seed(seed)

func find_closest_point(point): # SLOW
	var closest_dist = 64
	var closest = -1
	for i in range(0,path_points.size(),2):
		var l = (path_points[i]-point).length()
		if l < closest_dist:
			closest = i
			closest_dist = l
	return closest
