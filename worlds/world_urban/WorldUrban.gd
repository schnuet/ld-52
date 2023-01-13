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
	
	$LightningTimer.start(randi() % 20 + 5);


func _on_Timer_timeout():
	$LightningTimer.stop();
	$Lightning.visible = true;
	
	var anim = randi() % 3;
	if anim == 0:
		$Lightning.play("01");
	elif anim == 1:
		$Lightning.play("02");
	elif anim == 2:
		$Lightning.play("03");


func _on_Lightning_animation_finished():
	$Lightning.visible = false;
	$Lightning.frame = 0;
	$Lightning.stop();
	$LightningTimer.start(randi() % 20 + 5);
