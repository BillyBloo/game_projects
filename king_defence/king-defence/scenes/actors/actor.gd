extends CharacterBody2D

class_name actor

@export var unit_type = ""
@export var type = 0
var dead = false

enum control_modes {
	none,
	player,
	auto
}
@export var control_mode = control_modes.auto

var facing_dir = Vector2(1,0)
var vel = Vector2.ZERO
@onready var target_pos = position
@onready var pos = position

enum mov_states {
	idle,
	walking,
	stunned,
	attacking
}
var mov_state = mov_states.idle

@export var speed = 0.6
var lerp = 0.25

func _ready() -> void:
	var frame = $sprite.frame
	if type == 2:
		$sprite.animation = "monsters"
		$sprite.frame = frame
	else:
		$sprite.scale.x = -2
	randomize()
	Global.actors.append(self)
	#position.x += randf_range(-64,64)
	#position.y  += randf_range(-64,64)
	position = get_cell() * Navigator.cell_width
	target_pos = position
	set_collision_layer_value(type+1,true)
	#set_collision_mask_value(type,false)

func kill():
	Global.actors.erase(self)
	queue_free()

func _physics_process(delta: float) -> void:
	z_index = position.y*0.1
	if !Global.get_state_string() == "battle":
		return
	if dead:
		$CollisionShape2D.disabled = true
		visible = false
		return
	var dir = Vector2.ZERO
	match control_mode:
		control_modes.player:
			dir = Input.get_vector("left","right","up","down").normalized()
		control_modes.auto:
			var diff = target_pos - position
			dir = diff.normalized() * pow(diff.length() / Navigator.cell_width,0.4)
	if dir.length() > 0:
		facing_dir = dir

	if mov_state != mov_states.stunned and mov_state != mov_states.attacking:
		mov_state = mov_states.walking if dir.length() > 0 else mov_states.idle
	
	match mov_state:
		mov_states.idle, mov_states.attacking:
			vel = lerp(vel, Vector2.ZERO, lerp)
		mov_states.stunned:
			#$anim_player.play("flash",-1,0)
			vel = lerp(vel, Vector2.ZERO, lerp)
			if vel.length() < 1:
				mov_state = mov_states.idle
		mov_states.walking:
			if (target_pos - position).length() > 4:
				$anim_player.play("hop",-1,0.6)
			vel = lerp(vel, facing_dir * speed, lerp)
	pos += vel
	
	position.x = round(pos.x/2)*2
	position.y = round(pos.y/2)*2

func get_cell():
	return Vector2(round(position.x / Navigator.cell_width), round(position.y / Navigator.cell_width))

func move(dir):
	target_pos = dir * Navigator.cell_width + position
	#$sprite.scale.x = 2 if dir.x < 0 else -2
	#target_pos = (dir + get_cell()) * Navigator.cell_width


func _on_selector_pressed() -> void:
	if Global.get_state_string() == "place_units" and type == 1:
		Global.held_actor = self
