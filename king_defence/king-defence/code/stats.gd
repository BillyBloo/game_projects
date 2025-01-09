extends Node

var friendly_upgrades = []
var enemy_upgrades = []

var selected_stat = null
var stats = []

func _ready() -> void:
	var up1 = upgrade.new()
	up1.set_data("starter", {"king" : 1, "knight" : 3})
	friendly_upgrades.append(up1)
	
	var up2 = upgrade.new()
	up2.set_data("starter", {"king" : 1})
	enemy_upgrades.append(up2)

func update():
	for i in stats:
		i.update()

func get_units(friendly : bool):
	var units = {}
	var upgrades = friendly_upgrades if friendly else enemy_upgrades 
	for up : upgrade in upgrades:
		for i in up.given_units:
			if !units.keys().has(i):
				units[i] = up.given_units[i]
			else:
				units[i] += up.given_units[i]
	for i : actor in Global.actors:
		if (i.type == 1 and friendly) or (i.type == 2 and !friendly):
			if units.has(i.unit_type):
				units[i.unit_type] -= 1
	return units
