extends Node2D

func _ready() -> void:
	set_pos(Global.player.my_pos)

func set_pos(i):
	i = int(round(i))
	var s = Global.path_points.size()
	i = (i+s)%s
	position = Global.path_points[i]
	rotation = (Global.path_points[(i-1)%s]-Global.path_points[(i+1)%s]).angle()
	#$rod.look_at(get_global_mouse_position())
	#$rod.rotation = clamp($rod.rotation,deg_to_rad(-60),deg_to_rad(60))
