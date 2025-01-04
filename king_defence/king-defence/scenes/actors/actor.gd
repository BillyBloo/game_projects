extends CharacterBody2D

class_name actor

@export var type = 0

enum control_modes {
	none,
	player,
	auto
}
@export var control_mode = control_modes.auto

var facing_dir = Vector2(1,0)
var vel = Vector2.ZERO
@onready var target_pos = position

enum mov_states {
	idle,
	walking,
	stunned
}
var mov_state = mov_states.idle

var speed = 2
var lerp = 0.08

func _ready() -> void:
	Global.actors.append(self)
	position.x += randf_range(-64,64)
	position.y  += randf_range(-64,64)
	#position = get_cell() * Navigator.cell_width
	target_pos = position
	set_collision_layer_value(type,true)

func kill():
	Global.actors.erase(self)
	queue_free()

func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	match control_mode:
		control_modes.player:
			dir = Input.get_vector("left","right","up","down").normalized()
		control_modes.auto:
			var diff = target_pos - position
			dir = diff.normalized() * pow(diff.length() / Navigator.cell_width,0.4)
	if dir.length() > 0:
		facing_dir = dir
	if mov_state != mov_states.stunned:
		mov_state = mov_states.walking if dir.length() > 0 else mov_states.idle
	
	match mov_state:
		mov_states.idle:
			vel = lerp(vel, Vector2.ZERO, lerp)
		mov_states.stunned:
			vel = lerp(vel, Vector2.ZERO, lerp)
			if vel.length() < 1:
				mov_state = mov_states.idle
		mov_states.walking:
			vel = lerp(vel, facing_dir * speed, lerp)
	position += vel

func get_cell():
	return Vector2(round(position.x / Navigator.cell_width), round(position.y / Navigator.cell_width))

func move(dir):
	target_pos = dir * Navigator.cell_width + position
	#target_pos = (dir + get_cell()) * Navigator.cell_width
