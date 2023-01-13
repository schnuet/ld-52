extends Area2D

var harvester;

func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");

func activate():
	show();
	$CollisionShape2D.disabled = false;

func deactivate():
	hide();
	$CollisionShape2D.disabled = true;


func _on_CollectorOre_area_entered(area):
	if not visible:
		return;
	if harvester.is_collecting_ore():
		harvester.collect_ore();
		area.queue_free();
