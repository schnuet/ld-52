class_name HarvesterPart
extends Area2D;

var width = 0;
var height = 0;

signal selected;
signal deselected;

func select():
	var game = SceneManager.get_entity("Game");
	if (game.select_part(self)):
		emit_signal("selected");

func deselect():
	emit_signal("deselected");

func _on_mouse_down(event):
	print("mousedown ", event);
	select();

func _on_mouse_up(event):
	print("mouseup ", event);

func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			_on_mouse_down(event);
		else:
			_on_mouse_up(event);
