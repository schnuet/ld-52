extends Area2D


func activate():
	pass

func _on_Timer_timeout():
	if not visible:
		return;
		
	var areas = $Area2D.get_overlapping_areas();
	for area in areas:
		if area.has_method("damage"):
			area.damage(2);

