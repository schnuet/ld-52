extends Area2D


func _on_CreepDestroyer_area_entered(area):
	if area.is_in_group("creep") or area.is_in_group("bat") or area.is_in_group("charger"):
		area.queue_free();
		print(area.name, " destroyed");
