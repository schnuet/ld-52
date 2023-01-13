extends Area2D

var speed = 600;
var health = 10;

onready var animated_sprite:AnimatedSprite = $AnimatedSprite;

func _ready():
	var theme_color = Globals.get("theme_color");
	if animated_sprite.frames.has_animation(theme_color):
		animated_sprite.play(theme_color);
	else:
		animated_sprite.playing = true;

func _physics_process(delta):
	position.x -= speed * delta;

func damage(dmg):
	health -= dmg;
	if health <= 0:
		queue_free();

func _on_Charger_area_entered(_area):
	print("charger collided!");
	
	queue_free();

