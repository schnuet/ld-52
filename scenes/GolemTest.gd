extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.set("theme_color", "red");
	
	Globals.set("bio", 300);
	Globals.set("ore", 0);
	Globals.set("gas", 0);
	Globals.set("game_ready", true);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
