extends NinePatchRect

const BORDER_WIDTH := 15;
const MINIMUM_SIZE := Vector2(81, 81);

enum WINDOW_BOUNDARY_TYPE { TOP_LEFT, };

var initalRect := Rect2()
var cornerDragged : String;

var dragOffset := Vector2.ZERO;
var initalMousePos := Vector2.ZERO;

func calculateCornerClicked(mousePos: Vector2) -> String:
	var rect = get_global_rect();
	var left = mousePos.x < rect.position.x + BORDER_WIDTH;
	var right = mousePos.x > rect.end.x - BORDER_WIDTH;
	var top = mousePos.y < rect.position.y + BORDER_WIDTH;
	var bottom = mousePos.y > rect.end.y - BORDER_WIDTH;
	
	if left and top: return "top left";
	if left and bottom: return "bottom left";
	if right and top: return "top right";
	if right and bottom: return "bottom right";
	if left: return "left";
	if right: return "right";
	if top: return "top";
	if bottom: return "bottom";
	return "";

func _input(event) -> void:
	var mousePos = get_global_mouse_position()
	
	# Find the corner currently being dragged on click down
	if Input.is_action_just_pressed("LeftMouseButton"):
		var edge = calculateCornerClicked(mousePos);
		if edge != "":
			cornerDragged = edge;
			initalMousePos = mousePos;
			initalRect = get_global_rect();
			dragOffset = get_screen_position() - mousePos;
	
	# Move when click is down
	if Input.is_action_pressed("LeftMouseButton") and cornerDragged != "":
		var mouseDelta = mousePos - initalMousePos;
		
		var newPos = initalRect.position;
		var newSize = initalRect.size;
		
		if cornerDragged == "top":
			newPos = mousePos + dragOffset;
			
		set_global_position(newPos);
		set_size(newSize);
	
	# Reset variable when click is up
	if Input.is_action_just_released("LeftMouseButton"):
		cornerDragged = "";
