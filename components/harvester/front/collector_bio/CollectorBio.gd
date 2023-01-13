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

func _on_Collector_area_entered(area: Node):
	if not visible:
		return;
	if harvester.is_collecting_bio():
		harvester.collect_bio();
		area.splat();

func _on_CollectorBiomass_body_entered(body):
	if not visible:
		return;
	if harvester.is_collecting_bio():
		harvester.collect_bio();
		body.splat();
