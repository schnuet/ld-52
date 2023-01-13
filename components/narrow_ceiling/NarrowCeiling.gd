extends Area2D

var speed = 200;
var harvester: Harvester;

func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");
	speed = harvester.speed;
	harvester.connect("speed_changed", self, "adjust_speed");

func _physics_process(delta):
	position.x -= speed * delta;

func adjust_speed(new_speed, base_speed):
	speed = new_speed;


func _on_NarrowCeiling_area_entered(area):
	print("collide narrow", area);
	harvester.collide_with_stone();


func _on_NarrowCeiling_area_exited(area):
	print("leave narrow", area);
	harvester.leave_stone();
