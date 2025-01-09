extends Node2D

var pos : Vector2

func set_fog(corner,v):
	$fog.material.set("shader_parameter/"+corner,v)
	$fog_shadow.material.set("shader_parameter/"+corner,v)
