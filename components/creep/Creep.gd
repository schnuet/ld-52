extends KinematicBody2D

var speed = 200;

var game;

func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	game = SceneManager.get_entity("Game");
	
func _physics_process(_delta):
	if (Globals.get("paused")): return;
	
	var _v = move_and_slide(Vector2(-speed, 0));

func _enter_collector(_collector):
	print("enter collector");
	var biomass = Globals.get("biomass");
	game.set_biomass(biomass + 1);
	queue_free();
	
func _exit_collector(_collector):
	pass;

