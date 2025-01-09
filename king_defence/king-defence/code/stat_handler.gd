extends Control

var stats = {}

func _ready() -> void:
	for st : String in Stats.stats.keys():
		if st.begins_with("max_"):
			stats[st.lstrip("max_")].max_val = st
		else:
			var stat_scene = preload("res://scenes/stat.tscn").instantiate()
			add_child(stat_scene)
	Stats.stat_handler = self
	Stats.update()

func update():
	var units
	for i in get_children():
		i.update()
