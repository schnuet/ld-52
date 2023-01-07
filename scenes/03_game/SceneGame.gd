extends Scene

var selected_part: Node2D = null;

onready var ui = $UI;
onready var selected_light = $SelectedLight;
onready var canvas_modulate = $CanvasModulate;

# Global game variables here.
func _ready():
	Globals.set("paused", false);
	
	Globals.set("biomass", 0);
	Globals.set("ore", 0);
	Globals.set("gas", 0);
	
	Globals.set("harvester_speed", 200);
	Globals.set("base_harvester_speed", 200);
	
	Globals.set("game_ready", true);


func select_part(part: HarvesterPart):
	if selected_part != null:
		print("deselect part", selected_part);
		selected_part.deselect();
		selected_part = null;
		canvas_modulate.color = Color.white;
		return false;
	
	if part == null:
		if selected_part == null:
			return;
			
		selected_part = null;
		canvas_modulate.color = Color.white;
		return true;
	else:
		selected_part = part;
		canvas_modulate.color = Color.darkgray;
		return true;
	


# SETTERS

func set_biomass(value: int):
	Globals.set("biomass", value);
	print("set biomass ", Globals.get("biomass"));
	ui.update_biomass();

func set_ore(value: int):
	Globals.set("ore", value);
	print("set ore ", Globals.get("ore"));
	ui.update_ore();

func set_gas(value: int):
	Globals.set("gas", value);
	print("set gas ", Globals.get("gas"));
	ui.update_gas();
