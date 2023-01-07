extends Node2D

onready var sky = $Sky;
onready var clouds = $Clouds;
onready var dust = $Dust;
onready var light = $Light;
onready var mountains = $Mountains1;
onready var mountains2 = $Mountains2;
onready var middleground = $MiddleGround;

var harvester;

func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");
	harvester.connect("speed_changed", self, "");
	
	$AnimationPlayer.play("Parallax");
	
	$LightningTimer.start(randi() % 20 + 5);

func on_speed_change(new_speed: int, base_speed: int):
	$AnimationPlayer.playback_speed = new_speed / base_speed;


func _on_Timer_timeout():
	$LightningTimer.stop();
	$Lightning.visible = true;
	$Lightning.play("default");


func _on_Lightning_animation_finished():
	$Lightning.visible = false;
	$Lightning.frame = 0;
	$Lightning.stop();
	$LightningTimer.start(randi() % 20 + 5);
