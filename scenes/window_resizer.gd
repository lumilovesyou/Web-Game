extends NinePatchRect

const BORDER_WIDTH := 15
const MINIMUM_SIZE := Vector2(81, 81)

enum WINDOW_BOUNDARY_TYPE { TOP_LEFT, BOTTOM_LEFT, TOP_RIGHT, BOTTOM_RIGHT, LEFT, RIGHT, TOP, BOTTOM, NONE}

var inital_rect := Rect2()
var active_boundary : WINDOW_BOUNDARY_TYPE

var drag_offset := Vector2.ZERO
var inital_mouse_pos := Vector2.ZERO

func get_boundary_at_position(mouse_pos: Vector2) -> WINDOW_BOUNDARY_TYPE:
	var rect := get_global_rect()
	var left: bool = mouse_pos.x < rect.position.x + BORDER_WIDTH
	var right: bool = mouse_pos.x > rect.end.x - BORDER_WIDTH
	var top: bool = mouse_pos.y < rect.position.y + BORDER_WIDTH
	var bottom: bool = mouse_pos.y > rect.end.y - BORDER_WIDTH
	
	if left and top: return WINDOW_BOUNDARY_TYPE.TOP_LEFT
	if left and bottom: return WINDOW_BOUNDARY_TYPE.BOTTOM_LEFT
	if right and top: return WINDOW_BOUNDARY_TYPE.TOP_RIGHT
	if right and bottom: return WINDOW_BOUNDARY_TYPE.BOTTOM_RIGHT
	if left: return WINDOW_BOUNDARY_TYPE.LEFT
	if right: return WINDOW_BOUNDARY_TYPE.RIGHT
	if top: return WINDOW_BOUNDARY_TYPE.TOP
	if bottom: return WINDOW_BOUNDARY_TYPE.BOTTOM
	return WINDOW_BOUNDARY_TYPE.NONE

func _input(event: InputEvent) -> void:
	var mouse_pos := get_global_mouse_position()
	
	# Find the corner currently being dragged on click down
	if Input.is_action_just_pressed("LeftMouseButton"):
		var edge := get_boundary_at_position(mouse_pos)
		if edge != WINDOW_BOUNDARY_TYPE.NONE:
			active_boundary = edge
			inital_mouse_pos = mouse_pos
			inital_rect = get_global_rect()
			drag_offset = get_screen_position() - mouse_pos
	
	# Move when click is down
	if Input.is_action_pressed("LeftMouseButton") and active_boundary != WINDOW_BOUNDARY_TYPE.NONE:
		var mouse_delta := mouse_pos - inital_mouse_pos
		
		var new_pos := inital_rect.position
		var new_size := inital_rect.size
		
		match active_boundary:
			WINDOW_BOUNDARY_TYPE.TOP_LEFT:
				var potential_width := inital_rect.size.x - mouse_delta.x
				var potential_height := inital_rect.size.y - mouse_delta.y
				
				if potential_width >= MINIMUM_SIZE.x:
					new_pos.x = inital_rect.position.x + mouse_delta.x
					new_size.x = potential_width
				
				if potential_height >= MINIMUM_SIZE.y:
					new_pos.y = inital_rect.position.y + mouse_delta.y
					new_size.y = potential_height
					
			WINDOW_BOUNDARY_TYPE.BOTTOM_LEFT:
				var potential_width := inital_rect.size.x - mouse_delta.x				
				if potential_width >= MINIMUM_SIZE.x:
					new_pos.x = inital_rect.position.x + mouse_delta.x
					new_size.x = potential_width
				
				new_size.y = max(MINIMUM_SIZE.y, inital_rect.size.y + mouse_delta.y)
			WINDOW_BOUNDARY_TYPE.TOP_RIGHT:
				var potential_height := inital_rect.size.y - mouse_delta.y
				if potential_height >= MINIMUM_SIZE.y:
					new_pos.y = inital_rect.position.y + mouse_delta.y
					new_size.y = potential_height
				
				new_size.x = max(MINIMUM_SIZE.x, inital_rect.size.x + mouse_delta.x)
			WINDOW_BOUNDARY_TYPE.BOTTOM_RIGHT:
				new_size.x = max(MINIMUM_SIZE.x, inital_rect.size.x + mouse_delta.x)
				new_size.y = max(MINIMUM_SIZE.y, inital_rect.size.y + mouse_delta.y)
				
			WINDOW_BOUNDARY_TYPE.LEFT:
				var potential_width = inital_rect.size.x - mouse_delta.x
				if potential_width >= MINIMUM_SIZE.x:
					new_pos.x = inital_rect.position.x + mouse_delta.x
					new_size.x = potential_width
					
			WINDOW_BOUNDARY_TYPE.RIGHT:
				new_size.x = max(MINIMUM_SIZE.x, inital_rect.size.x + mouse_delta.x)
				
			WINDOW_BOUNDARY_TYPE.TOP:
				new_pos = mouse_pos + drag_offset
			WINDOW_BOUNDARY_TYPE.BOTTOM:
				new_size.y = max(MINIMUM_SIZE.y, inital_rect.size.y + mouse_delta.y)
			
		set_global_position(new_pos)
		set_size(new_size)
	
	# Reset variable when click is up
	if Input.is_action_just_released("LeftMouseButton"):
		active_boundary = WINDOW_BOUNDARY_TYPE.NONE
