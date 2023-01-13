extends Node2D

var Ore = preload("res://components/ore/Ore.tscn");

var group_spawn = 0;

func _on_Timer_timeout():
	var should_group_spawn = randi() % 10 == 0 or group_spawn > 0;
	
	var new_ore = Ore.instance();
	get_parent().add_child(new_ore);
	new_ore.global_position = global_position;
	new_ore.global_position.y += randi() % 30 - 15;
	new_ore.rotation_degrees = randi() % 360;
	
	if should_group_spawn:
		new_ore.scale = Vector2(0.5, 0.5) + randf() * Vector2(0.25, 0.25) - Vector2(0.125, 0.125);
	else:
		new_ore.scale = new_ore.scale + randf() * Vector2(0.5, 0.5) - Vector2(0.25, 0.25);
	
	if should_group_spawn:
		if group_spawn == 0:
			group_spawn = 3;
		group_spawn -= 1;
		$Timer.start(randf() * 0.2);
	else:
		$Timer.start(randi() % 4 + 3);
