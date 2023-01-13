extends Node2D



func _on_LightsTimer_timeout():
	
	# FADE IN
	$PolarLights/Tween.stop_all();
	$PolarLights/Tween.remove_all();
	$PolarLights/Tween.interpolate_property($PolarLights, "modulate", Color.transparent, Color.white, 1);
	$PolarLights/Tween.start();
	
	$PolarLights.frame = 0;
	$PolarLights.play("default");


func _on_PolarLights_animation_finished():
	$PolarLights.frame = 0;
	$PolarLights.play("default");
	
	# FADE OUT
	$PolarLights/Tween.stop_all();
	$PolarLights/Tween.remove_all();
	$PolarLights/Tween.interpolate_property($PolarLights, "modulate", Color.white, Color.transparent, 1);
	$PolarLights/Tween.start();
	
	$PolarLightsTimer.start(randi() % 10 + 6);
	
