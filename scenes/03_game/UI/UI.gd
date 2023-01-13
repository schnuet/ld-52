extends CanvasLayer

onready var bio_label = $MarginContainer/HBoxContainer/BiomassCounter/BiomassLabel;
onready var ore_label = $MarginContainer/HBoxContainer/OreCounter/OreLabel;
onready var gas_label = $MarginContainer/HBoxContainer/GasCounter/GasLabel;

onready var upgrade_buttons = {
	"blue": {
		"hover": preload("res://assets/upgrade_button/shadow_harvester_ui_upgrade_hover_blue.png"),
		"click": preload("res://assets/upgrade_button/shadow_harvester_ui_upgrade_click_blue.png"),
	},
	"red": {
		"hover": preload("res://assets/upgrade_button/shadow_harvester_ui_upgrade_hover_red.png"),
		"click": preload("res://assets/upgrade_button/shadow_harvester_ui_upgrade_click_red.png"),
	},
	"yellow": {
		"hover": preload("res://assets/upgrade_button/shadow_harvester_ui_upgrade_hover_yellow.png"),
		"click": preload("res://assets/upgrade_button/shadow_harvester_ui_upgrade_click_yellow.png"),
	}
};

func get_theme_color():
	var theme_color = Globals.get("theme_color");

func update_button_colors():
	var theme_color = Globals.get("theme_color");
	$ShopButton.texture_hover = upgrade_buttons[theme_color]["hover"];
	$ShopButton.texture_pressed = upgrade_buttons[theme_color]["click"];
	


func update_bio():
	bio_label.text = str(Globals.get("bio"));

func update_ore():
	ore_label.text = str(Globals.get("ore"));

func update_gas():
	gas_label.text = str(Globals.get("gas"));


func _on_ShopButton_pressed():
	var build_menu = SceneManager.get_entity("BuildMenu");
	build_menu.show();
