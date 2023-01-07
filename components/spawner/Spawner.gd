extends Node2D

var Creep = preload("res://components/creep/Creep.tscn");

onready var parent = get_parent();


func _on_GuyTimer_timeout():
	var new_guy = Creep.instance();
	new_guy.global_position = global_position;
	parent.add_child(new_guy);
