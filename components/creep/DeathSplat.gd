extends AnimatedSprite

func _ready():
	var l = frames.animations.size();
	var index = (randi() % l) + 1;
	play(str(index));

func _on_DeathSplat_animation_finished():
	queue_free();
