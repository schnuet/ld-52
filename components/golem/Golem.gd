extends Area2D

onready var animated_sprite = $AnimatedSprite;
var harvester: Harvester;

var state = "idle";

var has_damaged = false;
var harvester_is_here = false;
var max_health = 500;
var health = max_health;

func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");
	
	$Healthbar.set_max_health(max_health);
	
	play_animation("idle");

func _physics_process(delta):
	if harvester != null:
		position.x -= harvester.speed * delta;
	

func attack():
	smash();
	yield(animated_sprite, "animation_finished");
	
	if randi() % 2 == 0:
		laser();
		yield(animated_sprite, "animation_finished");
	
	play_animation("idle");
	
	$AttackTimer.start(randi() % 3 + 2);

func laser():
	play_animation("laser");

func smash():
	play_animation("smash");


func damage(dmg):
	health -= dmg;
	$Healthbar.set_health(health);
	
	print("golem damaged", dmg, health);
	if health <= 0:
		SceneManager.change_scene("res://scenes/98_win/SceneWin.tscn");

	$HurtLight.energy = 15;
	$HurtLight/Tween.stop_all();
	$HurtLight/Tween.reset_all();
	$HurtLight/Tween.interpolate_property($HurtLight, "energy", 15, 0, 0.5);
	$HurtLight/Tween.start();


func _on_AttackTimer_timeout():
	attack();


func _on_AnimatedSprite_animation_finished():
	if animated_sprite.animation == get_theme_color() + "-idle":
		return;
	
	play_animation("idle");


func is_animation(animation_name):
	return animated_sprite.animation == get_theme_color() + "-" + animation_name;

func _on_AnimatedSprite_frame_changed():
	if has_damaged:
		return;
		
	if is_animation("laser"):
		if animated_sprite.frame >= 17:
			apply_laser_damage();
			has_damaged = true;
	
	if is_animation("smash"):
		if animated_sprite.frame >= 20:
			apply_smash_damage();
			has_damaged = true;
		
	
func apply_laser_damage():
	var damage = 50;
	
	if not harvester.is_shield_active():
		damage += 250;
	
	if harvester.is_in_spider_mode():
		damage += 100;
	
	harvester.apply_damage(damage);

func apply_smash_damage():
	var damage = 50;
	
	if not harvester.is_shield_active():
		damage += 50;
	
	if not harvester.is_in_spider_mode():
		damage += 60;
	
	harvester.apply_damage(damage);


func _on_StageDetector_area_entered(area):
	if harvester_is_here:
		return;
	harvester_is_here = true;
	
	harvester.enter_golem_stage();
	
	# wait for the harvester to get ready for the fight.
	yield(harvester, "ready_for_fight");
	
	harvester.connect("anim_frame_changed", self, "on_harvester_frame_changed");
	
	$HarvesterTween.interpolate_property(harvester, "position:x", harvester.position.x, harvester.position.x + 200, 3);
	$HarvesterTween.start();
	yield($HarvesterTween, "tween_all_completed");
	
	smash();
	yield(animated_sprite, "animation_finished");
	
	smash();
	yield(animated_sprite, "animation_finished");
	
	smash();
	yield(animated_sprite, "animation_finished");
	
	return attack();

var damaged_by_player = false;

func on_harvester_frame_changed(frame):
	if frame != 18:
		damaged_by_player = false;
	if damaged_by_player:
		return;
	if harvester.is_cannon_active():
		print(frame);
		if frame == 18:
			take_cannon_damage();
			damaged_by_player = true;
			print("apply cannon damage");

func take_cannon_damage():
	var dmg = 10;
	if harvester.is_in_spider_mode():
		dmg += 50;
		
	damage(dmg);
		

func play_animation(animation_name):
	has_damaged = false;
	animated_sprite.play(get_theme_color() + "-" + animation_name);


func get_theme_color():
	return "red";
	# return Globals.get("theme_color");
