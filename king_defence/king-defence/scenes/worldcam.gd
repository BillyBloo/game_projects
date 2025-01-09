extends Camera2D

var zoom_exponent = 0

@onready var origin_pos = position
func _ready() -> void:
	Global.origin_pos = origin_pos

#func _input(event: InputEvent) -> void:
	#if event is InputEventScreenDrag and Global.held_actor == null and Stats.selected_stat == null and Global.get_state_string() == "battle":
		#position.x -= event.relative.x / zoom.x
		#position.x = clamp(position.x,270,270*3)
		#position.x = round(position.x/2)*2
		#posx = 270*2
	#return
	#var max = Vector2(810,540)
	#position.x = clamp(position.x,origin_pos.x,origin_pos.x)
	#position.y = clamp(position.y,origin_pos.y,origin_pos.y)
	#if Input.is_action_just_pressed("scrl_up"):
		#zoom_exponent -= 1
	#if Input.is_action_just_pressed("scrl_down"):
		#zoom_exponent += 1
	#zoom_exponent = clamp(zoom_exponent,0,16)
	#zoom = Vector2(0.75,0.75) * pow(1.05,zoom_exponent)

var posx = 270
func _physics_process(delta: float) -> void:
	match Global.get_state_string():
		"battle":
			posx = min(posx + 2, 270*2)
		"place_units", "menu":
			posx = max(posx - 2, 270)
		"pick_upgrades":
			posx = max(posx - 2, 270*2)
	position.x = posx
	position.x = clamp(position.x,270,270*3)
	position.x = round(position.x/2)*2
