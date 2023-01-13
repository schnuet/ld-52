class_name Harvester
extends Node2D

signal speed_changed(speed, base_speed);
signal ready_for_fight;
signal anim_frame_changed(frame);
signal collect(type, amount);

var health = 1000 setget set_health;

var base_speed = 200;
var speed = base_speed;

var floor_position = 0;
var fly_position = 0;
var walk_position = 0;

var move_state = "rolling";
var move_state_speeds = {
	"rolling": 200,
	"walking": 130,
	"flying": 400
};
var in_golem_stage = false;
var colliding_with_stone = false;

onready var body_tween = $BodyTween;

onready var top_part = $Anchor/Top;
onready var body_part = $Anchor/Body;
onready var front_part = $Anchor/Front;

onready var animated_sprites = {
	"chain": $Contruction/ChainAnimatedSprite,
	"spider": $Contruction/SpiderAnimatedSprite,
	"jet": $Contruction/JetAnimatedSprite
};
onready var current_animated_sprite = animated_sprites["chain"];


func _ready():
	floor_position = position.y;
	walk_position = floor_position - 65;
	fly_position = walk_position - 100;
	
	update_animated_sprite();

func set_health(val):
	health = val;
	var healthbar = SceneManager.get_entity("Healthbar");
	healthbar.set_health(val);

func apply_damage(dmg):
	
	set_health(health - dmg);
	
	print("harvester damaged ", dmg, " ", health);
	if health < 0:
		SceneManager.change_scene("res://scenes/97_game_over/SceneGameOver.tscn");

# MOVEMENT
func start_flying():
	if move_state == "flying":
		return;
		
	print("start flying");
	move_state = "flying";
	
	if not in_golem_stage and not colliding_with_stone:
		set_speed(move_state_speeds[move_state]);
		
	body_tween.stop_all();
	body_tween.remove_all();
	body_tween.interpolate_property(self, "position:y", position.y, fly_position, 2, Tween.TRANS_CUBIC, Tween.EASE_OUT);
	body_tween.start();

func start_rolling():
	if move_state == "rolling":
		return;
		
	move_state = "rolling";
	
	if not in_golem_stage and not colliding_with_stone:
		set_speed(move_state_speeds[move_state]);
		
	if body_tween.is_inside_tree():
		body_tween.stop_all();
		body_tween.remove_all();
		body_tween.interpolate_property(self, "position:y", position.y, floor_position, 0.125, Tween.TRANS_CUBIC, Tween.EASE_OUT);
		body_tween.start();
	else:
		position.y = floor_position;

func start_walking():
	if move_state == "walking":
		return;
		
	move_state = "walking";
	
	if not in_golem_stage and not colliding_with_stone:
		set_speed(move_state_speeds[move_state]);
	
	if body_tween.is_inside_tree():
		body_tween.stop_all();
		body_tween.remove_all();
		body_tween.interpolate_property(self, "position:y", position.y, walk_position, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT);
		body_tween.start();

func set_speed(value: int):
	if speed == value:
		return;
	
	# print("set speed ", value);
	speed = value;
	emit_signal("speed_changed", speed, base_speed);

func get_speed_factor():
	return float(speed) / float(base_speed);



func update_animated_sprite():
	var body_module_name = "chain";
	
	if body_part.active_module.name == "BodyChain":
		body_module_name = "chain";
	elif body_part.active_module.name == "BodySpider":
		body_module_name = "spider";
	elif body_part.active_module.name == "BodyJet":
		body_module_name = "jet";
	
	var animated_sprite = animated_sprites[body_module_name];
	
	var front_module_name = "bio";
	var front_module = front_part.active_module;
	if front_module.name == "CollectorBio":
		front_module_name = "bio";
	elif front_module.name == "CollectorOre":
		front_module_name = "ore";
	elif front_module.name == "CollectorGas":
		front_module_name = "gas";
	
	var top_module_name = "shield";
	var top_module = top_part.active_module;
	if top_module.name == "HeadShield":
		top_module_name = "shield";
	elif top_module.name == "HeadCannon":
		top_module_name = "cannon";
	elif top_module.name == "HeadCoil":
		top_module_name = "coil";

	var animation_name = front_module_name + "-" + top_module_name;
	
	print("update animation name ", animation_name);
	
	animated_sprite.animation = animation_name;
	animated_sprite.playing = true;
	animated_sprite.visible = true;
	
	if animated_sprite != current_animated_sprite:
		current_animated_sprite.visible = false;
		current_animated_sprite = animated_sprite;


func is_collecting_bio():
	return front_part.active_module.name == "CollectorBio";
	
func is_collecting_ore():
	return front_part.active_module.name == "CollectorOre";
	
func is_collecting_gas():
	return front_part.active_module.name == "CollectorGas";


func is_cannon_active():
	return top_part.active_module.name == "HeadCannon";

func is_shield_active():
	return top_part.active_module.name == "HeadShield";

func is_in_spider_mode():
	return body_part.active_module.name == "BodySpider";




func collect_bio(amount = 1):
	emit_signal("collect", "bio", amount);

func collect_ore(amount = 1):
	emit_signal("collect", "ore", amount);
	
func collect_gas(amount = 1):
	emit_signal("collect", "gas", amount);



func collide_with_stone():
	colliding_with_stone = true;
	if speed != 0:
		set_speed(0);

func leave_stone():
	colliding_with_stone = false;
	if not in_golem_stage:
		set_speed(move_state_speeds[move_state]);
	
	



func enter_golem_stage():
	in_golem_stage = true;
	
	$GolemEnterTween.interpolate_method(self, "set_speed", speed, 0, 3, Tween.TRANS_CUBIC, Tween.EASE_OUT);
	$GolemEnterTween.start();

#func _on_Top_selected():
#	$Anchor.move_child(top_part, $Anchor.get_child_count() - 1);
#func _on_Body_selected():
#	$Anchor.move_child(body_part, $Anchor.get_child_count() - 1);
#func _on_Front_selected():
#	$Anchor.move_child(front_part, $Anchor.get_child_count() - 1);


func _on_GolemEnterTween_tween_all_completed():
	emit_signal("ready_for_fight");


func _on_ChainAnimatedSprite_frame_changed():
	if $Contruction/ChainAnimatedSprite.visible:
		emit_signal("anim_frame_changed", $Contruction/ChainAnimatedSprite.frame);


func _on_SpiderAnimatedSprite_frame_changed():
	if $Contruction/SpiderAnimatedSprite.visible:
		emit_signal("anim_frame_changed", $Contruction/SpiderAnimatedSprite.frame);


func _on_JetAnimatedSprite_frame_changed():
	if $Contruction/JetAnimatedSprite.visible:
		emit_signal("anim_frame_changed", $Contruction/JetAnimatedSprite.frame);
