extends Node

const Tile = preload("res://scenes/Tile.tscn")

const DEFAULT_GRID_SIZE = Vector2(6, 6)

class Map extends Node:
	var grid_size = DEFAULT_GRID_SIZE
	
	func _init(_grid_size = DEFAULT_GRID_SIZE) -> void:
		grid_size = _grid_size
	
	func randomize_tiles():
		for tile in get_children():
			tile.set_random_mode()
	
	func next_tile():
		for tile in get_children():
			tile.set_next_mode()
	
	func highlight_tile(tile_to_check):
		for tile in get_children():
			if tile_to_check != null && tile_to_check == tile:
				tile.highlight()
			else:
				tile.unhighlight()
	func save_map():
		var export_array = []
		for tile in get_children():
			export_array.append({
				"mode": tile.get_mode(),
				"position": [tile.transform.origin.x, tile.transform.origin.y, tile.transform.origin.z]
			})
		
		var folder_name = "saved_maps"
		var dir = Directory.new()
		dir.open("./")
		dir.make_dir(folder_name)
		
		var filename = "./" + folder_name + "/saved_map_" + str(OS.get_system_time_msecs()) + ".lvl"
		var file = File.new()
		file.open(filename, File.WRITE)
		file.store_string(to_json({ 
			"grid_size": grid_size,
			"tiles": export_array
		}))
		file.close()
		print("Saved map to: " + filename)

func generate_map(grid_size = DEFAULT_GRID_SIZE) -> Node:
	var map = Map.new(grid_size)
	map.name = "Map"
	for x in grid_size.x:
		for y in grid_size.y:
			var new_tile = Tile.instance()
			new_tile.set_position(x, y, grid_size)
			new_tile.set_mode(new_tile.MODES.FLOOR)
			map.add_child(new_tile)
	return map

func load_map(path):
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	
	var result = JSON.parse(content).result
	var map = Map.new(result["grid_size"])
	map.name = "Map"
	for tile_data in result["tiles"]:
		var new_tile = Tile.instance()
		new_tile.transform.origin = Vector3(tile_data["position"][0], tile_data["position"][1], tile_data["position"][2])
		new_tile.set_mode(tile_data["mode"])
		map.add_child(new_tile)
	return map
	


