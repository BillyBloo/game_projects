extends Node

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit(0)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("place_rod"):
		var rod = preload("res://scenes/fishing_rod.tscn").instantiate()
		add_child(rod)

func _ready() -> void:
	var points = generate_lake_points()
	$lake_polygon.polygon = points
	$lake_outline.points = points
	Global.lake_points = points
	
	var path = []
	for i in points.size():
		var a = points[i]
		var b = points[(i+1) % points.size()]
		path.append(a - (a-b).normalized().rotated(-PI*0.5) * 24)
	path = even_spacing(path,8)
	path = subdiv(path,0)
	path = even_spacing(path,8)
	
	Global.path_points = path
	$path.points = path
	$player.set_pos(0)
	var avg_point = Vector2.ZERO
	for i in points.size():
		avg_point += points[i]*(1.0/points.size())
	$cam.position = avg_point

func generate_lake_points() -> PackedVector2Array:
	const MAX_SIZE = Vector2(960,540)
	const CENTRE = MAX_SIZE * 0.5
	var point_num = 12
	var points = []
	for i in point_num:
		var angle = (float(i)/point_num)*2*PI
		points.append(Vector2(randf_range(100,270),0).rotated(angle) + CENTRE)
	
	var variance = 30
	for i in 5:
		points = subdiv(points, variance)
		variance *= 0.25
	points = even_spacing(points, 5)
	return points

func subdiv(points, variance) -> PackedVector2Array:
	var subdived_points = []
	for i in points.size():
		var a = points[i]
		var b = points[(i+1) % points.size()]
		subdived_points.append(lerp(a,b,0.25) + Vector2(randf_range(0,variance),0).rotated(randf_range(0,2*PI)))
		subdived_points.append(lerp(a,b,0.75) + Vector2(randf_range(0,variance),0).rotated(randf_range(0,2*PI)))
	return subdived_points

func even_spacing(points, spacing : float) -> PackedVector2Array:
	var evened_points = []
	var dist_leftover = 0
	for i in points.size():
		var a = points[i]
		var b = points[(i+1) % points.size()]
		var dist = (a-b).length()+dist_leftover
		while dist > spacing:
			var point = lerp(a,b,spacing / dist)
			a = point
			evened_points.append(point)
			dist = (a-b).length()
			dist_leftover = 0
		dist_leftover += (a-b).length()
	return evened_points
