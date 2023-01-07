class_name AreaButton
extends Area2D

signal mouse_up;
signal mouse_down;

func _on_mouse_down(event):
	emit_signal("mouse_down", event);

func _on_mouse_up(event):
	emit_signal("mouse_up", event);

func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			_on_mouse_down(event);
		else:
			_on_mouse_up(event);
