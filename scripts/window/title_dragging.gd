extends PanelContainer

signal drag_started
signal window_focused

var dragging := false
var drag_offset := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():	
			dragging = true
			drag_offset = get_global_mouse_position() - get_node("../../").global_position
			window_focused.emit()
			get_viewport().set_input_as_handled()
		else:
			dragging = false
	elif event is InputEventMouseMotion && dragging:
		var window := get_node("../../") as Control
		window.global_position = get_global_mouse_position() - drag_offset
		get_viewport().set_input_as_handled()
