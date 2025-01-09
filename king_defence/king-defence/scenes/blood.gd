extends CPUParticles2D

func _ready() -> void:
	amount += randi_range(-2,2)
	emitting = true
	await get_tree().create_timer(0.65/speed_scale).timeout
	set_process(false)
	set_process_internal(false)
