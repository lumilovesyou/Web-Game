extends NinePatchRect

const BORDER_WIDTH := 10
const MINIMUM_SIZE := Vector2(81, 81)

enum WINDOW_BOUNDARY {
	NONE,
	TOP_LEFT,
	BOTTOM_LEFT,
	TOP_RIGHT,
	BOTTOM_RIGHT,
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}

var inital_rect := Rect2()
var active_boundary := WINDOW_BOUNDARY.NONE

var drag_offset := Vector2.ZERO
var inital_mouse_pos := Vector2.ZERO
var cursor_shape := Input.CURSOR_ARROW

func get_boundary_at_position(rect: Rect2, mouse_pos: Vector2) -> WINDOW_BOUNDARY:
	var left: bool = mouse_pos.x <= rect.position.x + BORDER_WIDTH
	var right: bool = mouse_pos.x >= rect.end.x - BORDER_WIDTH
	var top: bool = mouse_pos.y <= rect.position.y + BORDER_WIDTH
	var bottom: bool = mouse_pos.y >= rect.end.y - BORDER_WIDTH
	
	if left and top: return WINDOW_BOUNDARY.TOP_LEFT
	if left and bottom: return WINDOW_BOUNDARY.BOTTOM_LEFT
	if right and top: return WINDOW_BOUNDARY.TOP_RIGHT
	if right and bottom: return WINDOW_BOUNDARY.BOTTOM_RIGHT
	if left: return WINDOW_BOUNDARY.LEFT
	if right: return WINDOW_BOUNDARY.RIGHT
	if top: return WINDOW_BOUNDARY.TOP
	if bottom: return WINDOW_BOUNDARY.BOTTOM
	return WINDOW_BOUNDARY.NONE
	
func manage_cursor(mouse_pos: Vector2, rect: Rect2) -> void:
	var edge := get_boundary_at_position(rect, mouse_pos)
	
	match edge:
		WINDOW_BOUNDARY.TOP_LEFT, WINDOW_BOUNDARY.BOTTOM_RIGHT:
			Input.set_default_cursor_shape(Input.CURSOR_FDIAGSIZE)
		WINDOW_BOUNDARY.TOP_RIGHT, WINDOW_BOUNDARY.BOTTOM_LEFT:
			Input.set_default_cursor_shape(Input.CURSOR_BDIAGSIZE)
		WINDOW_BOUNDARY.LEFT, WINDOW_BOUNDARY.RIGHT:
			Input.set_default_cursor_shape(Input.CURSOR_HSIZE)
		WINDOW_BOUNDARY.TOP, WINDOW_BOUNDARY.BOTTOM:
			Input.set_default_cursor_shape(Input.CURSOR_VSIZE)
		WINDOW_BOUNDARY.NONE:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var rect := get_global_rect()
	
	if not rect.has_point(mouse_pos) && active_boundary == WINDOW_BOUNDARY.NONE:
		return
	
	if cursor_shape == Input.CURSOR_ARROW:
		manage_cursor(mouse_pos, rect)

func _input(event: InputEvent) -> void:
	var mouse_pos := get_global_mouse_position()
	var rect := get_global_rect()
	
	if not rect.has_point(mouse_pos) && active_boundary == WINDOW_BOUNDARY.NONE:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		return
		
	var edge := get_boundary_at_position(rect, mouse_pos)
	
	# Find the corner currently being dragged on click down
	if Input.is_action_just_pressed("LeftMouseButton"):
		if edge != WINDOW_BOUNDARY.NONE:
			active_boundary = edge
			inital_mouse_pos = mouse_pos
			inital_rect = get_global_rect()
			drag_offset = get_screen_position() - mouse_pos
			
			manage_cursor(mouse_pos, rect)
			cursor_shape = Input.get_current_cursor_shape();
	
	# Move when click is down
	if Input.is_action_pressed("LeftMouseButton") and active_boundary != WINDOW_BOUNDARY.NONE:
		var mouse_delta := mouse_pos - inital_mouse_pos
		
		var new_pos := inital_rect.position
		var new_size := inital_rect.size
		
		match active_boundary:
			WINDOW_BOUNDARY.TOP_LEFT:
				new_size.x = max(MINIMUM_SIZE.x, inital_rect.size.x - mouse_delta.x)
				new_pos.x = inital_rect.end.x - new_size.x
				new_size.y = max(MINIMUM_SIZE.y, inital_rect.size.y - mouse_delta.y)
				new_pos.y = inital_rect.end.y - new_size.y
				
			WINDOW_BOUNDARY.BOTTOM_LEFT:
				new_size.x = max(MINIMUM_SIZE.x, inital_rect.size.x - mouse_delta.x)
				new_pos.x = inital_rect.end.x - new_size.x
				new_size.y = max(MINIMUM_SIZE.y, inital_rect.size.y + mouse_delta.y)
				
			WINDOW_BOUNDARY.TOP_RIGHT:
				new_size.x = max(MINIMUM_SIZE.x, inital_rect.size.x + mouse_delta.x)
				new_size.y = max(MINIMUM_SIZE.y, inital_rect.size.y - mouse_delta.y)
				new_pos.y = inital_rect.end.y - new_size.y
				
			WINDOW_BOUNDARY.BOTTOM_RIGHT:
				new_size.x = max(MINIMUM_SIZE.x, inital_rect.size.x + mouse_delta.x)
				new_size.y = max(MINIMUM_SIZE.y, inital_rect.size.y + mouse_delta.y)
				
			WINDOW_BOUNDARY.LEFT:
				new_size.x = max(MINIMUM_SIZE.x, inital_rect.size.x - mouse_delta.x)
				new_pos.x = inital_rect.end.x - new_size.x
					
			WINDOW_BOUNDARY.RIGHT:
				new_size.x = max(MINIMUM_SIZE.x, inital_rect.size.x + mouse_delta.x)
				
			WINDOW_BOUNDARY.TOP:
				new_pos = mouse_pos + drag_offset
			
			WINDOW_BOUNDARY.BOTTOM:
				new_size.y = max(MINIMUM_SIZE.y, inital_rect.size.y + mouse_delta.y)
			
		set_global_position(new_pos)
		set_size(new_size)
	
	# Reset variable when click is up
	if Input.is_action_just_released("LeftMouseButton"):
		active_boundary = WINDOW_BOUNDARY.NONE
		cursor_shape = Input.CURSOR_ARROW
