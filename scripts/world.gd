extends Spatial

#const GRID_SIZE = Vector2(25, 25)

func _ready():
	$SaveButton.connect("button_up", self, "_on_save_map_button_pressed")
	$LoadButton.connect("button_up", self, "_on_load_map_button_pressed")
	$FileDialog.connect("file_selected", self, "_on_file_selected")
	
	var map = MapManager.generate_map()
	add_child(map)
	
func _on_save_map_button_pressed():
	$Map.save_map()
	
func _on_load_map_button_pressed():
	$FileDialog.popup()
	
func _on_file_selected(path):
	var map = MapManager.load_map(path)
	$Map.queue_free()
	add_child(map)
	
