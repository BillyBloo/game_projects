extends Node

var cell_width = 36

var tl : Vector2
var br : Vector2
var boundary = 1

var navmap_to_friendlies : navmap = null
var navmap_to_enemies : navmap = null

var last_d = 1000
var first_update = true
func update_navmaps():
	Global.cull()
	
	tl = Vector2(1000000,1000000)
	br = Vector2(-1000000,-1000000)
	var actors = Global.get_actors_by_type()
	var solid = get_cells(actors[0])
	var friendly = get_cells(actors[1])
	var enemy = get_cells(actors[2])
	
	tl -= Vector2(boundary,boundary)
	br += Vector2(boundary,boundary)
	
	var new_navmap_to_friendlies = await generate_navmap(friendly,solid,remove_duplicates(get_cells(actors[2])))
	var new_navmap_to_enemies = await generate_navmap(enemy,solid,remove_duplicates(get_cells(actors[1])))
	
	navmap_to_friendlies = new_navmap_to_friendlies
	navmap_to_enemies = new_navmap_to_enemies
	
	if first_update:
		await get_tree().physics_frame
	first_update = false
	return navmap_to_enemies.map.keys() + navmap_to_friendlies.map.keys()

func remove_duplicates(list):
	var out = []
	for i in list:
		if i not in out:
			out.append(i)
	return out

func step_movement():
	if navmap_to_enemies == null or navmap_to_friendlies == null:
		return
	var actors = Global.get_actors_by_type()
	var solid = get_cells(actors[0])
	var friendly = get_cells(actors[1])
	var enemy = get_cells(actors[2])
	var taken_cells = {}
	for i in friendly+enemy:
		taken_cells[i] = i
	taken_cells = move_with(actors[1], navmap_to_enemies, taken_cells)
	taken_cells = move_with(actors[2], navmap_to_friendlies, taken_cells)

func push_apart(m):
	var actor_set = Global.get_actors_by_cell()
	for cell in actor_set.keys():
		var actors = actor_set[cell]
		if actors.size() <= 1:
			continue
		var avg_pos = Vector2.ZERO
		for act in actors:
			avg_pos += act.position * (1.0 / actors.size())
		for act : actor in actors:
			var diff = (act.position - avg_pos)
			#act.move(diff.normalized()*(m/max(diff.length(),1.0)))
			act.vel = lerp(act.vel,diff.normalized()*act.speed*m,0.3)

func move_with(actors, map, taken_cells):
	for i : actor in actors:
		var cell = i.get_cell()
		if !map.map.has(cell):
			#i.move(-cell.normalized()*min(1,cell.length()))
			continue
		var target_cell = cell + map.map[cell]
		if map.best_dists[cell] > 1.5 and !taken_cells.has(target_cell):
			i.move(map.map[cell])
			taken_cells[target_cell] = i
	return taken_cells

func get_cells(actors):
	var out = []
	for i in actors:
		var cell = i.get_cell()
		tl = Vector2(min(tl.x,cell.x), min(tl.y,cell.y))
		br = Vector2(max(br.x,cell.x), max(br.y,cell.y))
		out.append(cell)
	return out

#func get_cells_by_type(actors, type):
	#var out = []
	#for i in actors:
		#if (i as actor).type == type:
			#out.append(i.get_cell())
	#return out

func generate_navmap(zero_set, solid_set, terminal_set):
	var nav = navmap.new()
	if terminal_set.size() == 0:
		return nav
	for i in zero_set:
		nav.add(i,Vector2.ZERO)
	return await add_neighbours(nav,solid_set, terminal_set)

const NEIGHBOURS = [Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1),
					Vector2(-1,0), Vector2(1,0),
					Vector2(-1,1), Vector2(0,1), Vector2(1,1)]
#const NEIGHBOURS = [Vector2(0,-1),
					#Vector2(-1,0), Vector2(1,0),
					#Vector2(0,1)]
func add_neighbours(nav : navmap, solid_set, terminal_set):
	var d = 0
	var w = 1.1
	var t_size = terminal_set.size() * 0.0
	while terminal_set.size() > t_size and d < 10000:
		d += 1
		var unchecked = nav.unchecked.keys()
		if unchecked.size() == 0:
			last_d = d
			return nav
		#var avg_pos = Vector2.ZERO
		#for i in terminal_set:
			#avg_pos += i * (1.0/terminal_set.size())
		#for i in max(unchecked.size(), terminal_set.size()):
		var best = 0
		for j in unchecked.size():
			if nav.best_dists[unchecked[j]] < nav.best_dists[unchecked[best]]:
				best = j
		var from_cell = unchecked[best]
		unchecked.remove_at(best)
		nav.check(from_cell)
		if from_cell in terminal_set:
			terminal_set.erase(from_cell)
			if terminal_set.size() == 0:
				return nav
		if !solid_set.has(from_cell):
			for j in NEIGHBOURS:
				var cell : Vector2 = from_cell - j
				if nav.map.has(cell) and nav.best_dists[cell] < nav.best_dists[from_cell]+j.length():
					continue
				if cell.x < tl.x or cell.y < tl.y or cell.x > br.x or cell.y > br.y:
					continue
				nav.add(cell,j)
		if d % max(int(floor(float(last_d) / 30.0)),1) == 0 and !first_update:
			await get_tree().physics_frame
	last_d = d
	return nav

func sleep(sec):
	await get_tree().create_timer(sec).timeout

func eval(cell, goal, w):
	var val = (cell - goal).length() * w
	return val

#func eval(goal_dir, i_dir):
	#var val = 0
	#if pos(goal_dir.x) * pos(i_dir.x) > 0:
		#val += 1
	#if pos(goal_dir.y) * pos(i_dir.y) > 0:
		#val += 1
	#return val
#func pos(a):
	#if a > 0:
		#return 1
	#elif a < 0:
		#return -1
	#return 0
