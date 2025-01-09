extends Node2D

var t = 0

func _ready() -> void:
	position = Navigator.cell_width * Vector2(1.5,1.5)

func _physics_process(delta: float) -> void:
	if Global.held_actor != null or Stats.selected_stat != null:
		t = max(t-delta*10,0)
	else:
		t = min(t+delta*10,1)
	var c = cos(t*PI)*0.5+0.5
	modulate.a = c*0.3
