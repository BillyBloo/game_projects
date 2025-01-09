extends Control

func _ready() -> void:
	main()

@export var state = ""

func main():
	while true:
		visible = Global.get_state_string() == state
		if state == "place_units":
			visible = visible and Global.get_actors_by_type()[1].size() > 0
		await get_tree().create_timer(0.1).timeout
