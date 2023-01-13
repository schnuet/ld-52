extends Node2D

var Bat = preload("res://components/bat/Bat.tscn");
var Creep = preload("res://components/creep/Creep.tscn");
var Charger = preload("res://components/charger/Charger.tscn");
var StoneGround = preload("res://components/stone_ground/StoneGround.tscn");
var DirtWall = preload("res://components/dirt_wall/DirtWall.tscn");
var Golem = preload("res://components/golem/Golem.tscn");
var Checkpoint = preload("res://components/harvester_checkpoint/HarvesterCheckpoint.tscn");
var NarrowCeiling = preload("res://components/narrow_ceiling/NarrowCeiling.tscn");

signal done;

export var phase = 1;

var bats_to_spawn = 5;

onready var bat_position = $BatPosition;

onready var phase_timer = $PhaseTimer;
onready var bat_timer = $BatTimer;
onready var extra_bat_timer = $BatTimer/ExtraBatTimer;
onready var creep_timer = $CreepTimer;
onready var charger_timer = $ChargerTimer;
onready var weather_timer = $WeatherTimer;
onready var weather_start_timer = $WeatherTimer/WeatherStartTimer;
onready var weather_tween = $WeatherTimer/WeatherTween;
onready var weather_end_tween = $WeatherTimer/WeatherEndTween;
onready var weather_end_timer = $WeatherTimer/WeatherEndTimer;

onready var parent = get_parent();


var creeps_active = false;
var creep_min_time = 4;
var creep_rand_time = 0;

var chargers_active = false;
var chargers_min_time = 4;
var chargers_rand_time = 0;

var bats_active = false;
var bats_min_time = 4;
var bats_rand_time = 0;

var game;

func start_chargers():
	charger_timer.start(2);


func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	game = SceneManager.get_entity("Game");
	
	start_next_phase();


# PHASES

func start_next_phase():
	
	
	match phase:
		1:
			print("start phase 1");
			
			spawn_creep();
			
			yield (wait(6), "done");
			
			spawn_creep();
			yield (wait(0.3), "done");
			
			spawn_creep();
			yield (wait(1), "done");
			
			spawn_creep();
			yield (wait(0.5), "done");
			
			spawn_creep();
			yield (wait(1), "done");
			
			start_spawning_creeps(2);
			yield (wait(12), "done");
			
			# learn how to use the shop:
			spawn_ground_multiple(5);
			var check = spawn_checkpoint(global_position.x + 500);
			yield(check, "reached");
			
			start_spawning_creeps(0.5, 1);
			start_spawning_bats(5, 7);
			spawn_ground_multiple(2);
			yield(wait(15), "done");
			
			spawn_ground_multiple(3);
			var check_2 = spawn_checkpoint(global_position.x + 500);
			yield(check_2, "reached");
			
			yield(wait(10), "done");
			
			spawn_ceiling();
			var check_3 = spawn_checkpoint(global_position.x + 500);
			yield(check_3, "reached");
			
			yield(wait(10), "done");
			spawn_ground_multiple(2);
			
			yield(wait(12), "done");
			spawn_ground_multiple(10);
			
			yield(wait(30), "done");
			
			spawn_wall();
			
			yield(wait(50), "done");
			spawn_golem();
		2:
			print("start phase 2");
			creep_timer.start(2);
			charger_timer.start(3);
			bat_timer.start(20);
			weather_timer.start(10);
			phase_timer.start(10);
		3:
			print("start phase 3");
			creep_timer.start(0.2);
			charger_timer.start(2);
			bat_timer.start(5);
			weather_timer.start(5);
			phase_timer.start(10);
		_:
			creep_timer.start(randf() * 3 + 0.25);
			charger_timer.start(randf() * 10 + 2);
			bat_timer.start(randf() * 20 + 2);
			weather_timer.start(randi() % 10 + 5);
	
			phase_timer.start(randi() % 20 + 5);
			
	phase += 1;

func spawn_charger():
	var new_charger = Charger.instance();
	parent.add_child(new_charger);
	new_charger.global_position = global_position;

func spawn_creep():
	var new_creep = Creep.instance();
	parent.add_child(new_creep);
	new_creep.global_position = global_position;

func spawn_bat():
	var new_bat = Bat.instance();
	parent.add_child(new_bat);
	new_bat.global_position = bat_position.global_position;
	new_bat.global_position.y += (randi() % 200) - 100;
	new_bat.center_y = bat_position.global_position.y;
	new_bat.new_target_y();

func spawn_ground():
	var ground = StoneGround.instance();
	parent.add_child(ground);
	ground.global_position = global_position;
	print("ground spawned at", ground.global_position);
	return ground;

func spawn_ground_multiple(l: int):
	for i in range(l):
		var ground = spawn_ground();
		ground.position.x += i * 100;


func spawn_wall():
	var wall = DirtWall.instance();
	parent.add_child(wall);
	wall.global_position = global_position;
	print("wall spawned at", wall.global_position.x);
	return wall;

func spawn_ceiling():
	var wall = NarrowCeiling.instance();
	parent.add_child(wall);
	wall.global_position = global_position;
	print("ceiling spawned at", wall.global_position.x);
	return wall;
	

func spawn_checkpoint(x):
	var point = Checkpoint.instance();
	parent.add_child(point);
	point.global_position = global_position;
	point.global_position.x = x;
	print("checkpoint spawned at", point.global_position.x);
	return point;

func spawn_golem():
	var golem = Golem.instance();
	parent.add_child(golem);
	golem.global_position = global_position;
	return golem;


func start_spawning_creeps(min_time, rand_time = 0):
	creeps_active = true;
	creep_min_time = min_time;
	creep_rand_time = rand_time;
	creep_timer.start(0);

func stop_spawning_creeps():
	creeps_active = false;
	creep_timer.stop();


func start_spawning_bats(min_time, rand_time = 0):
	bats_active = true;
	bats_min_time = min_time;
	bats_rand_time = rand_time;
	bat_timer.start(0);

func stop_spawning_bats():
	bats_active = false;
	bat_timer.stop();
	
	
func start_spawning_chargers(min_time, rand_time = 0):
	chargers_active = true;
	chargers_min_time = min_time;
	chargers_rand_time = rand_time;
	charger_timer.start(0);

func stop_spawning_chargers():
	chargers_active = false;
	charger_timer.stop();
	

func wait(time):
	$WaitTimer.start(time);
	return self;

func start_weather():
	if Globals.get("weather_active"):
		return;
	
	if weather_tween.is_active():
		return;
		
	
	game.current_weather.show();
	game.current_weather.modulate = Color.transparent;
	weather_start_timer.start(2);
	

func end_weather():
	Globals.set("weather_active", false);
	game.current_weather.hide();


func _on_GuyTimer_timeout():
	spawn_creep();
	
	if creeps_active:
		creep_timer.start(creep_min_time + randf() * creep_rand_time);
	

func _on_ChargerTimer_timeout():
	spawn_charger();
	
	if chargers_active:
		charger_timer.start(chargers_min_time + randf() * chargers_rand_time);



func _on_BatTimer_timeout():
	spawn_bat();
	bats_to_spawn = randi() % 8 + 3;
	$BatTimer/ExtraBatTimer.start(randf() * 0.05);
	
	if bats_active:
		bat_timer.start(bats_min_time + randf() * bats_rand_time);


func _on_ExtraBatTimer_timeout():
	bats_to_spawn -= 1;
	spawn_bat();
	if bats_to_spawn > 0:
		$BatTimer/ExtraBatTimer.start(randf() * 0.1);


func _on_PhaseTimer_timeout():
	start_next_phase();




# WEATHER

func _on_WeatherTimer_timeout():
	start_weather();


func _on_WeatherStartTimer_timeout():
	weather_tween.stop_all();
	weather_tween.remove_all();
	weather_tween.interpolate_property(game.current_weather, "modulate", Color.transparent, Color.white, 1);
	weather_tween.start();

func _on_WeatherTween_tween_all_completed():
	Globals.set("weather_active", true);
	$WeatherTimer/WeatherEndTimer.start(randi() % 5 + 5);
	
func _on_WeatherEndTimer_timeout():
	weather_end_tween.stop_all();
	weather_end_tween.remove_all();
	weather_end_tween.interpolate_property(game.current_weather, "modulate", Color.white, Color.transparent, 1);
	weather_end_tween.start();

func _on_WeatherEndTween_tween_all_completed():
	end_weather();


func _on_WaitTimer_timeout():
	emit_signal("done");
