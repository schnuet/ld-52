extends Area2D


func _on_CreepDestroyer_area_entered(area):
	if area.is_in_group("creep"):
		area.queue_free();
