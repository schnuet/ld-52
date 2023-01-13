extends Area2D

var speed = 200;
var health = 5;
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


func _on_DirtWall_area_entered(area):
	if area.is_in_group("harvester_part"):
		print(area, area.name, area.get_parent().name);
		harvester.collide_with_stone();


func damage(dmg):
	health -= dmg;
	if health <= 0:
		queue_free();

func _on_DirtWall_area_exited(area: Node2D):
	if area.is_in_group("harvester_part"):
		harvester.leave_stone();
