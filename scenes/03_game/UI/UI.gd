extends CanvasLayer

onready var biomass_label = $MarginContainer/HBoxContainer/BiomassCounter/BiomassLabel;
onready var ore_label = $MarginContainer/HBoxContainer/OreCounter/OreLabel;
onready var gas_label = $MarginContainer/HBoxContainer/GasCounter/GasLabel;

func update_biomass():
	biomass_label.text = str(Globals.get("biomass"));

func update_ore():
	ore_label.text = str(Globals.get("ore"));

func update_gas():
	gas_label.text = str(Globals.get("gas"));
