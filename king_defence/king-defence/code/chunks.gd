extends Node

func _ready() -> void:
	var w = 1
	for i in range(-1,5,1):
		for j in range(-1,3,1):
			var chunk = preload("res://scenes/chunk.tscn").instantiate()
			chunk.position = Vector2(i*270,j*270)
			chunk.pos = Vector2(i,j)
			Fog.chunks[Vector2(i,j)] = chunk
			Fog.fog_points[Vector2(i,j)] = 1.0
			add_child(chunk)


var t_a = 0
var t_b = 0

func _physics_process(delta: float) -> void:
	var d = delta
	match Global.get_state_string():
		"battle":
			t_a = min(1, t_a + d)
			t_b = min(1, t_b + d)
		"place_units":
			t_a = min(1, t_a + d)
			t_b = max(0, t_b - d)
		"menu", "pick_upgrades":
			t_a = max(0, t_a - d)
			t_b = max(0, t_b - d)
	var a = pow(cos(t_a*PI*0.5),2)
	var b = pow(cos(t_b*PI*0.5),2)
	
	Fog.set_fog_at_point(Vector2(1,1),a)
	Fog.set_fog_at_point(Vector2(2,1),b)
	Fog.set_fog_at_point(Vector2(3,1),b)
