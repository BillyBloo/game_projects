extends Node2D

var t_pos = 0
var dir = 1
var my_pos = 0

func _ready() -> void:
	Global.player = self

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("m1"):
		var p = Global.find_closest_point(get_global_mouse_position())
		if p != -1:
			var s = Global.path_points.size()
			if (p > my_pos or my_pos > p +s*0.5) and my_pos > p - s*0.5:
				dir = 1 
				t_pos = p # clockwise
			else:
				dir = -1
				t_pos = p # anticlockwise
	if t_pos != my_pos:
		set_pos(my_pos+dir)

func set_pos(i):
	var s = Global.path_points.size()
	i = fmod(i+s,s)
	my_pos = i
	position = Global.path_points[i]
