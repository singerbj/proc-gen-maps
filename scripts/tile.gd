extends Spatial

enum MODES { 
	EMPTY, FLOOR, BLOCK, BLOCK_HALF
	CORNER_NE, CORNER_SE, CORNER_SW, CORNER_NW, 
	SLOPE_N, SLOPE_E, SLOPE_S, SLOPE_W,
	SLOPE_HALF_N, SLOPE_HALF_E, SLOPE_HALF_S, SLOPE_HALF_W
}

const POSSIBLE_MODES = [
	MODES.EMPTY, MODES.FLOOR, MODES.BLOCK, MODES.BLOCK_HALF,
	MODES.CORNER_NE, MODES.CORNER_SE, MODES.CORNER_SW, MODES.CORNER_NW, 
	MODES.SLOPE_N, MODES.SLOPE_E, MODES.SLOPE_S, MODES.SLOPE_W,
	MODES.SLOPE_HALF_N, MODES.SLOPE_HALF_E, MODES.SLOPE_HALF_S, MODES.SLOPE_HALF_W
]
const CORNER_MODES = [MODES.CORNER_NE, MODES.CORNER_SE, MODES.CORNER_SW, MODES.CORNER_NW]
const SLOPE_MODES = [MODES.SLOPE_N, MODES.SLOPE_E, MODES.SLOPE_S, MODES.SLOPE_W]
const SLOPE_HALF_MODES = [MODES.SLOPE_HALF_N, MODES.SLOPE_HALF_E, MODES.SLOPE_HALF_S, MODES.SLOPE_HALF_W]

const TILE_SIZE = 10
const OVERLAP = 0.5

var _mode = POSSIBLE_MODES[0]

func highlight():
	$Highlight.visible = true
						
func unhighlight():
	$Highlight.visible = false
					
func get_mode():
	return _mode

func set_mode(mode : int):
	_mode = mode
	
	_hide_floor()
	_hide_block()
	_hide_block_half()
	_hide_corner()
	_hide_slope()
	_hide_slope_half()
	if mode != MODES.EMPTY:
		_show_floor()
		if mode == MODES.FLOOR:
			pass
		elif mode == MODES.BLOCK:
			_show_block()
		elif mode == MODES.BLOCK_HALF:
			_show_block_half()
		elif CORNER_MODES.has(mode):
			_show_corner()
			if mode == MODES.CORNER_NE:
				rotation_degrees = Vector3(0, 0, 0)
			elif mode == MODES.CORNER_SE:
				rotation_degrees = Vector3(0, 270, 0)	
			elif mode == MODES.CORNER_SW:
				rotation_degrees = Vector3(0, 180, 0)
			elif mode == MODES.CORNER_NW:
				rotation_degrees = Vector3(0, 90, 0)
				
		elif SLOPE_MODES.has(mode):
			_show_slope()
			if mode == MODES.SLOPE_N:
				rotation_degrees = Vector3(0, 90, 0)
			elif mode == MODES.SLOPE_E:
				rotation_degrees = Vector3(0, 0, 0)
			elif mode == MODES.SLOPE_S:
				rotation_degrees = Vector3(0, 270, 0)
			elif mode == MODES.SLOPE_W:
				rotation_degrees = Vector3(0, 180, 0)
				
		elif SLOPE_HALF_MODES.has(mode):
			_show_slope_half()
			if mode == MODES.SLOPE_HALF_N:
				rotation_degrees = Vector3(0, 90, 0)
			elif mode == MODES.SLOPE_HALF_E:
				rotation_degrees = Vector3(0, 0, 0)
			elif mode == MODES.SLOPE_HALF_S:
				rotation_degrees = Vector3(0, 270, 0)
			elif mode == MODES.SLOPE_HALF_W:
				rotation_degrees = Vector3(0, 180, 0)
		else:
			print("Error: mode not recognized: ", MODES.keys()[mode])
func set_random_mode():
	randomize()
	var mode_to_set = POSSIBLE_MODES[randi() % POSSIBLE_MODES.size()]
	set_mode(mode_to_set)
	
func set_next_mode():
	var next_mode = _mode + 1
	if next_mode > POSSIBLE_MODES.size() - 1:
		next_mode = 0
	set_mode(next_mode)
	
func reset_mode():
	set_mode(POSSIBLE_MODES[0])
	
func set_position(x : int, y : int, grid_size : Vector2 = Vector2(1, 1)):
	var grid_offset_x = (grid_size.x - 1) * TILE_SIZE / 2
	var grid_offset_y = (grid_size.y - 1) * TILE_SIZE / 2
	
	transform.origin = Vector3((x * TILE_SIZE) - (x * OVERLAP) - grid_offset_x , 0, (y * TILE_SIZE)  - (y * OVERLAP) - grid_offset_y)

func _show_floor():
	$Floor.visible = true
	
func _hide_floor():
	$Floor.visible = false

func _show_block():
	$Block.visible = true
	
func _hide_block():
	$Block.visible = false
	
func _show_block_half():
	$BlockHalf.visible = true
	
func _hide_block_half():
	$BlockHalf.visible = false

func _show_corner():
	$Corner.visible = true
	
func _hide_corner():
	$Corner.visible = false
	
func _show_slope():
	$Slope.visible = true
	
func _hide_slope():
	$Slope.visible = false

func _show_slope_half():
	$SlopeHalf.visible = true
	
func _hide_slope_half():
	$SlopeHalf.visible = false
