extends Scene

onready var ui = $UI;
onready var selected_light = $SelectedLight;
onready var canvas_modulate = $CanvasModulate;

var current_background;
var current_foreground;
var current_weather: AnimatedSprite;

onready var backgrounds = $Backgrounds.get_children();
onready var foregrounds = $Foregrounds.get_children();

var healthbar;

# Global game variables here.
func _ready():
	Globals.set("paused", false);
	
	Globals.set("theme_color", "red");
	
	set_bio(0);
	set_ore(0);
	set_gas(0);
	
	Globals.set("harvester_speed", 200);
	Globals.set("base_harvester_speed", 200);
	
	Globals.set("weather_active", false);
	
	Globals.set("game_ready", true);
	
	for background in backgrounds:
		background.visible = false;
	for foreground in foregrounds:
		foreground.visible = false;
	
	healthbar = $UI/Healthbar;
			
	switch_world("urban");
	

func switch_world(world_name):
	
	match(world_name):
		"urban":
			Globals.set("theme_color", "red");
		"ice":
			Globals.set("theme_color", "blue");
		"sulfur":
			Globals.set("theme_color", "yellow");
		_:
			pass
	
	ui.update_button_colors();
	
	healthbar.update_bar_color();
	
	MusicPlayer.play_music(world_name);
	
	# hide old backgrounds
	if current_background:
		current_background.visible = false;
	if current_foreground:
		current_foreground.visible = false;
	if current_weather:
		current_weather.visible = false;
		current_weather.playing = false;
		
	# load background
	var new_bg;
	if $Backgrounds.has_node(world_name):
		new_bg = $Backgrounds.get_node(world_name);
	else:
		new_bg = load("res://worlds/world_" + world_name);
		$Backgrounds.add_child(new_bg);
	new_bg.visible = true;
	current_background = new_bg;
	
	# load foreground
	var new_fg = $Foregrounds.get_node(world_name);
	new_fg.visible = true;
	current_foreground = new_fg;
	
	# load weather
	current_weather = new_fg.get_node("Weather");
	current_weather.playing = true;


# SETTERS

func set_bio(value: int):
	Globals.set("bio", value);
	ui.update_bio();

func set_ore(value: int):
	Globals.set("ore", value);
	ui.update_ore();

func set_gas(value: int):
	Globals.set("gas", value);
	ui.update_gas();
