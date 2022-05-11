extends Camera

export(float) var mouse_sensitivity = 0.05
export(float) var camera_speed = 15

const X_AXIS = Vector3(1, 0, 0)
const Y_AXIS = Vector3(0, 1, 0)
const RAY_LENGTH = 1000
const SPRINT_MODIFIER = 1.75

var is_mouse_motion = false

var mouse_speed = Vector2()
var mouse_speed_x = 0
var mouse_speed_y = 0

var total_mouse_motion := Vector2(0, 1000)
var head_angle = 0

var world
func _ready():
	 world = get_parent()
	
func _input(event) -> void:
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
	
	if (Input.is_key_pressed(KEY_SPACE)):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if (Input.is_key_pressed(KEY_N)):
		world.get_node("Map").next_tile()
	
	if (Input.is_key_pressed(KEY_R)):
		world.get_node("Map").randomize_tiles()
		
	if (Input.is_mouse_button_pressed(BUTTON_LEFT)):
		var tile = get_tile_via_raycast()
		if tile:
			tile.set_next_mode()
			
	if (Input.is_mouse_button_pressed(BUTTON_RIGHT)):
		var tile = get_tile_via_raycast()
		if tile:
			tile.reset_mode()
		
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			total_mouse_motion += event.relative
		else:
			var tile = get_tile_via_raycast()
			var map = world.get_node("Map")
			if map:
				map.highlight_tile(tile)

func get_tile_via_raycast():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = project_ray_origin(mouse_pos)
	var ray_to = ray_from + project_ray_normal(mouse_pos) * RAY_LENGTH
	var space_state = get_world().direct_space_state
	var all_results = []
	var all_colliders = []
	var hit_player = false
	var continue_casting = true
	while(continue_casting):		
		var result = space_state.intersect_ray(ray_from, ray_to, [self] + all_colliders)
		if 'collider_id' in result:
			all_results.append(result)
			all_colliders.append(result.collider)
		else:
			continue_casting = false
	if all_results.size() > 0:
		return all_results[all_results.size() - 1].collider

func _process(delta):
	# Rotate body
	rotation_degrees.y -= mouse_sensitivity * total_mouse_motion.x
	head_angle -= mouse_sensitivity * total_mouse_motion.y
	head_angle = clamp(head_angle, -80, 80)
	rotation_degrees.x = head_angle
	total_mouse_motion = Vector2()
	
	var speed = camera_speed
	if (Input.is_key_pressed(KEY_SHIFT)):
		speed = camera_speed * SPRINT_MODIFIER
	
	var movement = Vector3(0, 0, 0)
	if (Input.is_key_pressed(KEY_W)):
		movement += -Vector3(0, 0, 1) * speed * delta
	
	if (Input.is_key_pressed(KEY_S)):
		movement += Vector3(0, 0, 1) * speed * delta
	
	if (Input.is_key_pressed(KEY_A)):
		movement += -Vector3(1, 0, 0) * speed * delta
	
	if (Input.is_key_pressed(KEY_D)):
		movement += Vector3(1, 0, 0) * speed * delta
	
	if (Input.is_key_pressed(KEY_Q)):
		movement += -Vector3(0, 1, 0) * speed * delta
	
	if (Input.is_key_pressed(KEY_E)):
		movement += Vector3(0, 1, 0) * speed * delta
		
	movement = movement.rotated(Vector3.UP, rotation.y)
	
	transform.origin += movement
