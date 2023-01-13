extends Control

var max_health = 1000;
var health = max_health;

func set_max_health(value):
	max_health = value;
	if health > max_health:
		health = max_health;
	update_bar();

func set_health(value):
	health = value;
	if health < 0:
		health = 0;
	update_bar();

func update_bar():
	var percent = float(health) / float(max_health);
	$over.scale.y = -percent;
	

func update_bar_color():
	$over.animation = Globals.get("theme_color");
	$under.animation = Globals.get("theme_color");
