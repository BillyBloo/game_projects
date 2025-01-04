extends actor

func _ready() -> void:
	super._ready()
	if type == 2:
		$Icon.modulate = Color.RED
	$melee_area.set_collision_mask_value(3-type,true)

var hp = 100
@onready var attack_cooldown = randi_range(30,60)

func attack(target : actor, dmg):
	var knockback = (target.position - position).normalized() * dmg * 0.1
	target.hurt(dmg, knockback)
	vel -= knockback * 0.5
	mov_state = mov_states.stunned
	attack_cooldown = randi_range(30,60)
func hurt(dmg, knockback):
	vel += knockback
	mov_state = mov_states.stunned
	hp = max(0, hp-dmg)
	$hp_bar.visible = true
	$hp_bar.value = hp

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if hp <= 0 and mov_state != mov_states.stunned:
		kill()
		return
	if $melee_area.get_overlapping_bodies().size() > 0 and mov_state != mov_states.stunned:
		attack_cooldown = max(attack_cooldown-1,0)
		if attack_cooldown == 0:
			attack($melee_area.get_overlapping_bodies()[0], 25)
