extends Area2D

var overlapping_areas = [];
var overlapping_bodies = [];

var harvester;

func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");

func activate():
	pass;

func _on_Collector_area_entered(area: Node):
	overlapping_areas.append(area);
	
	if (area.has_method("_enter_collector")):
		area._enter_collector(self);

func _on_Collector_area_exited(area):
	overlapping_areas.erase(area);
	
	if (area.has_method("_exit_collector")):
		area._exit_collector(self);


func _on_BiomassCollector_body_entered(body):
	overlapping_bodies.append(body);
	
	if (body.has_method("_enter_collector")):
		body._enter_collector(self);


func _on_BiomassCollector_body_exited(body):
	overlapping_bodies.erase(body);
	
	if (body.has_method("_exit_collector")):
		body._exit_collector(self);
