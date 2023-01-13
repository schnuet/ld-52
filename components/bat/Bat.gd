extends Area2D

var speed = 600;

var center_y = 0;
var target_y = 0;

func _ready():
	scale = scale * (0.7 + randf() * 0.6);

func _physics_process(delta):
	position.x -= speed * delta;
	
	var y_difference = target_y - global_position.y;
	
	position.y += y_difference * 2 * delta;
	
	if abs(y_difference) < 0.1:
		new_target_y();
	

func new_target_y():
	target_y = center_y + (randi() % 200) - 100;

