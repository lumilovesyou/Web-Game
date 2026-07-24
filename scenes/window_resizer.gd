extends NinePatchRect

const BORDER_WIDTH := 15;
var cornerDragged : String;
var dragOffset := Vector2.ZERO;

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
	# Find the corner currently being dragged on click down
	if Input.is_action_just_pressed("LeftMouseButton"):
		var edge = calculateCornerClicked(get_global_mouse_position());
		if edge != "":
			cornerDragged = edge;
			dragOffset = get_screen_position() - get_global_mouse_position();
	
	# Move when click is down
	if Input.is_action_pressed("LeftMouseButton"):
		if cornerDragged == "top":
			set_position(get_global_mouse_position() + dragOffset)
	
	# Reset variable when click is up
	if Input.is_action_just_released("LeftMouseButton"):
		cornerDragged = "";
