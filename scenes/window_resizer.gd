extends NinePatchRect

const BORDER_WIDTH := 15;
const MINIMUM_SIZE := Vector2(81, 81);

enum WINDOW_BOUNDARY_TYPE { TOP_LEFT, BOTTOM_LEFT, TOP_RIGHT, BOTTOM_RIGHT, LEFT, RIGHT, TOP, BOTTOM, NONE};

var inital_rect := Rect2()
var corner_dragged : WINDOW_BOUNDARY_TYPE;

var drag_offset := Vector2.ZERO;
var inital_mouse_pos := Vector2.ZERO;

func calculate_corner_clicked(mouse_pos: Vector2) -> WINDOW_BOUNDARY_TYPE:
	var rect := get_global_rect();
	var left: bool = mouse_pos.x < rect.position.x + BORDER_WIDTH;
	var right: bool = mouse_pos.x > rect.end.x - BORDER_WIDTH;
	var top: bool = mouse_pos.y < rect.position.y + BORDER_WIDTH;
	var bottom: bool = mouse_pos.y > rect.end.y - BORDER_WIDTH;
	
	if left and top: return WINDOW_BOUNDARY_TYPE.TOP_LEFT;
	if left and bottom: return WINDOW_BOUNDARY_TYPE.BOTTOM_LEFT;
	if right and top: return WINDOW_BOUNDARY_TYPE.TOP_RIGHT;
	if right and bottom: return WINDOW_BOUNDARY_TYPE.BOTTOM_RIGHT;
	if left: return WINDOW_BOUNDARY_TYPE.LEFT;
	if right: return WINDOW_BOUNDARY_TYPE.RIGHT;
	if top: return WINDOW_BOUNDARY_TYPE.TOP;
	if bottom: return WINDOW_BOUNDARY_TYPE.BOTTOM;
	return WINDOW_BOUNDARY_TYPE.NONE;

func _input(event: InputEvent) -> void:
	var mouse_pos := get_global_mouse_position()
	
	# Find the corner currently being dragged on click down
	if Input.is_action_just_pressed("LeftMouseButton"):
		var edge := calculate_corner_clicked(mouse_pos);
		if edge != WINDOW_BOUNDARY_TYPE.NONE:
			corner_dragged = edge;
			inital_mouse_pos = mouse_pos;
			inital_rect = get_global_rect();
			drag_offset = get_screen_position() - mouse_pos;
	
	# Move when click is down
	if Input.is_action_pressed("LeftMouseButton") and corner_dragged != WINDOW_BOUNDARY_TYPE.NONE:
		var mouseDelta := mouse_pos - inital_mouse_pos;
		
		var new_pos := inital_rect.position;
		var new_size := inital_rect.size;
		
		if corner_dragged == WINDOW_BOUNDARY_TYPE.TOP:
			new_pos = mouse_pos + drag_offset;
			
		set_global_position(new_pos);
		set_size(new_size);
	
	# Reset variable when click is up
	if Input.is_action_just_released("LeftMouseButton"):
		corner_dragged = WINDOW_BOUNDARY_TYPE.NONE;
