extends actor

class_name has_hp

@export var hp = 100
@onready var max_hp = hp
@onready var hp_bar = $hp_anchor/hp_bar

func _ready() -> void:
	super._ready()
	hp_bar.max_value = hp
	hp_bar.value = hp
	hp_bar.visible = false
	$hp_anchor.scale.x *= pow(float(hp)/100.0,0.5)

func heal(amt):
	hp = min(hp+amt,max_hp)
	hp_bar.value = hp
	if hp == max_hp:
		hp_bar.visible = false
func hurt(dmg, knockback):
	var blood : CPUParticles2D = preload("res://scenes/blood.tscn").instantiate()
	blood.direction = knockback.normalized() - Vector2(0,0.5)
	blood.z_index = z_index - 10 
	blood.position += position
	get_parent().add_child(blood)
	vel += knockback
	mov_state = mov_states.stunned
	hp = max(0, hp-dmg)
	hp_bar.visible = true
	hp_bar.value = hp

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if hp <= 0 and mov_state != mov_states.stunned:
		dead = true
		return
