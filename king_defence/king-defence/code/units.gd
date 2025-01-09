extends Control

var units = {}

func _ready() -> void:
	for unit : String in Stats.get_units(true):
		var stat_scene = preload("res://scenes/stat.tscn").instantiate()
		add_child(stat_scene)
	Stats.stats.append(self)
	call_deferred("update")

func update():
	visible = Global.get_state_string() == "place_units"
	var units = Stats.get_units(true)
	var y = 0
	for i in units.keys().size():
		var v = units[units.keys()[i]]
		if v == 0 and Stats.selected_stat == get_child(i):
			Stats.selected_stat = null
		get_child(i).update(units.keys()[i],v)
		get_child(i).position.y = y
		#if v > 0:
		y += 32+8
