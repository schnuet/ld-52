extends Area2D

signal reached;

var harvester: Harvester;

func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");

func _on_HarvesterCheckpoint_area_entered(area):
	print("harvester entered checkpoint");
	emit_signal("reached"); 

func _physics_process(delta):
	position.x -= harvester.speed * delta;
	
