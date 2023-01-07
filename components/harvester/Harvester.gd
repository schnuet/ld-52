extends Node2D

signal speed_changed;

var base_speed = 200;
var speed = base_speed;

func set_speed(value: int):
	speed = value;
	emit_signal("speed_changed", speed, base_speed);

func _on_Top_selected():
	move_child($Top, get_child_count() - 1);


func _on_Body_selected():
	move_child($Body, get_child_count() - 1);


func _on_Front_selected():
	move_child($Front, get_child_count() - 1);
