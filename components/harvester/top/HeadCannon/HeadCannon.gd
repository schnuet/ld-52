extends Area2D

func fire():
	$Hitbox/CollisionShape2D.disabled = false;
	$Hitbox/Timer.start(0.4);
	yield($Hitbox/Timer, "timeout");
	$Hitbox/CollisionShape2D.disabled = true;

func activate():
	pass

func _on_Hitbox_area_entered(area):
	if not visible:
		return;
	if area.has_method("damage"):
		area.damage(10);

func _on_Timer_timeout():
	if not visible:
		return;
		
	fire();
