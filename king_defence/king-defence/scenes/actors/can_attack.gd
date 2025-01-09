extends has_hp

class_name can_attack

func _ready() -> void:
	super._ready()
	$melee_area.set_collision_mask_value(4-type,true)
	$melee_area/CollisionShape2D.scale *= attack_range

@export var attack_interval = 50
@onready var attack_cooldown = attack_interval*0.25
@export var attack_dmg = 25
@export var attack_range = 1.0

func attack(target : actor, dmg):
	var knockback = (target.position - position).normalized() * dmg * 0.1
	target.hurt(dmg, knockback)
	vel -= knockback * 0.5
	mov_state = mov_states.stunned
	attack_cooldown = attack_interval + randi_range(-5,5)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if dead:
		return
	if $melee_area.get_overlapping_bodies().size() > 0 and mov_state != mov_states.stunned:
		attack_cooldown = max(attack_cooldown-1,0)
		#`target_pos = position
		mov_state = mov_states.attacking
		if attack_cooldown == 0:
			attack($melee_area.get_overlapping_bodies()[0], attack_dmg)
	elif mov_state == mov_states.attacking:
		mov_state = mov_states.idle
