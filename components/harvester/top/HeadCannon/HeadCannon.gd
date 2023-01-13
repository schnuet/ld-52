extends Area2D

var harvester: Harvester;

func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");
	
	harvester.connect("anim_frame_changed", self, "_on_harvester_anim_frame");

func fire():
	$Hitbox/CollisionShape2D.disabled = false;
	$Hitbox/Timer.start(0.2);
	yield($Hitbox/Timer, "timeout");
	$Hitbox/CollisionShape2D.disabled = true;

func activate():
	show();
	$CollisionShape2D.disabled = false;

func deactivate():
	hide();
	$CollisionShape2D.disabled = true;
	
func _on_harvester_anim_frame(frame):
	if not harvester.is_cannon_active():
		return;
	if frame == 16:
		fire();

func _on_Hitbox_area_entered(area):
	if not visible:
		return;
	if area.has_method("damage"):
		area.damage(10);
