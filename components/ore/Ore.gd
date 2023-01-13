extends Area2D

var harvester: Harvester;

func _ready():
	var theme_color = Globals.get("theme_color");
	get_node(theme_color).show();
	
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");


func _physics_process(delta):
	position.x -= harvester.speed * delta;
