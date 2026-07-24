extends Control

enum Edge { 
	LEFT,
	RIGHT,
	TOP,
	BOTTOM,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}

# need to fix window background breaking with stretch/tile

@export var edge: Edge
const MIN_SIZE := Vector2(81, 81)

var resizing := false;
var start_mouse := Vector2.ZERO;
var start_rect := Rect2()

func _gui_input(event: InputEvent) -> void:
	var window := get_parent() as Control
	print(window)
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			resizing = true
			start_mouse = get_global_mouse_position()
			start_rect = Rect2(window.global_position, window.size); #Rect2(window.global_position, window.size)?
		else:
			resizing = false
	elif event is InputEventMouseMotion && resizing:
		var delta := get_global_mouse_position() - start_mouse
		var new_pos := start_rect.position
		var new_size := window.size
		
		if edge in [Edge.RIGHT, Edge.TOP_LEFT, Edge.BOTTOM_LEFT]:
			new_size.x = max(MIN_SIZE.x, start_rect.size.x - delta.x)
			new_pos.x = start_rect.end.x - new_size.x
		if edge in [Edge.LEFT, Edge.TOP_RIGHT, Edge.BOTTOM_RIGHT]:
			new_size.x = max(MIN_SIZE.x, start_rect.size.x + delta.x)
		if edge in [Edge.TOP, Edge.TOP_LEFT, Edge.TOP_RIGHT]:
			new_size.y = max(MIN_SIZE.y, start_rect.size.y - delta.y)
			new_pos.y = start_rect.end.y - new_size.y
		if edge in [Edge.BOTTOM, Edge.BOTTOM_LEFT, Edge.BOTTOM_RIGHT]:
			new_size.y = max(MIN_SIZE.y, start_rect.size.y + delta.y)
			
		window.global_position = new_pos
		window.size = new_size
