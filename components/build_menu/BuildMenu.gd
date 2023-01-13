extends CanvasLayer

var harvester;

var module_infos = {
	"BodyChain": {
		"name": "Shadowcrawler",
		"part": "body_part",
		"description": "In this form you can avoid hovering rocks. \n«Creeps hate this trick.»",
		"price": {
			"bio": 0,
			"ore": 0,
			"gas": 0
		}
	},
	"BodySpider": {
		"name": "Spiderwalker",
		"part": "body_part",
		"description": "In this form you can walk on unstable ground. \n«You’ll never win a game of whack-a-mole like this.»",
		"price": {
			"bio": 5,
			"ore": 0,
			"gas": 0
		}
	},
	"BodyJet": {
		"name": "Hoverjet",
		"part": "body_part",
		"description": "In this form you can travel with accelerated speed. \n«To infinity and beyond, baby.»",
		"price": {
			"bio": 50,
			"ore": 20,
			"gas": 0
		}
	},
	
	"CollectorBio": {
		"name": "The Haecksler",
		"part": "front_part",
		"description": "A gruesome weapon to shred your enemies in to pieces. \n«Takin‘ the grind to the next level.»",
		"price": {
			"bio": 0,
			"ore": 0,
			"gas": 0
		}
	},
	"CollectorOre": {
		"name": "Can-ye-drill",
		"part": "front_part",
		"description": "This tool can prospect ore from the ground. \n«Now I ain't sayin' she a gold digger…»",
		"price": {
			"bio": 200,
			"ore": 0,
			"gas": 0
		}
	},
	"CollectorGas": {
		"name": "Egg sac",
		"part": "front_part",
		"description": "This tool can collect gas out of the air. \n«Take a deep breath and make it pop.»",
		"price": {
			"bio": 200,
			"ore": 30,
			"gas": 0
		}
	},
	
	"HeadShield": {
		"name": "Shield",
		"part": "top_part",
		"description": "This tool can protect you from any incoming damage. \n«Don‘t be silly - protect your willie.»",
		"price": {
			"bio": 0,
			"ore": 0,
			"gas": 0
		}
	},
	"HeadCannon": {
		"name": "Vaporizer",
		"part": "top_part",
		"description": "A distance weapon to vaporize your enemies. \n«Do not try this at home - your lungs won’t thank you.»",
		"price": {
			"bio": 30,
			"ore": 0,
			"gas": 0
		}
	},
	"HeadCoil": {
		"name": "Coil of Grayskull",
		"part": "top_part",
		"description": "This is the most powerful weapon in your arsenal. \n«By the power of grayskull - i have the power.»",
		"price": {
			"bio": 100,
			"ore": 20,
			"gas": 5
		}
	}
};
var selected_module_name = "";

onready var name_label = $MarginContainer/Panel/SelectedItem/SelectedTitle;
onready var description_label = $MarginContainer/Panel/SelectedItem/SelectedDescription;
onready var buy_button = $MarginContainer/Panel/SelectedItem/BuyButton;

onready var bio_price_label = $MarginContainer/Panel/SelectedItem/Prices/BioPrice;
onready var ore_price_label = $MarginContainer/Panel/SelectedItem/Prices/OrePrice;
onready var gas_price_label = $MarginContainer/Panel/SelectedItem/Prices/GasPrice;


func _ready():
	visible = false;
	
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");

func _process(_delta):
	if not visible:
		return;
	update_buy_button();


func show():
	.show();
	get_tree().paused = true;
	print("pause tree?", get_tree().paused);

func hide():
	.hide();
	get_tree().paused = false;
	
	
func has_enough_resources(module_name):
	var bio = Globals.get("bio");
	var ore = Globals.get("ore");
	var gas = Globals.get("gas");
	
	var module_info = module_infos[module_name];
	var price = module_info.price;
	
	if bio < price["bio"]:
		return false;
		
	if ore < price["ore"]:
		return false;
		
	if gas < price["gas"]:
		return false;
		
	return true;
	
func get_part(module_name):
	var module_info = module_infos[module_name];
	return harvester.get(module_info["part"]);
	
func is_bought(module_name):
	var part = get_part(module_name);

	return part.bought_modules[module_name];


func select_module(module_name):
	selected_module_name = module_name;
	
	var module_info = module_infos[module_name];
	description_label.text = module_info["description"];
	
	print(module_info["price"]);
	
	name_label.text = module_info["name"];
	
	# update needed resources
	bio_price_label.text = str(module_info["price"]["bio"]);
	ore_price_label.text = str(module_info["price"]["ore"]);
	gas_price_label.text = str(module_info["price"]["gas"]);
	
	# show / hide resource labels
	if module_info["price"]["bio"] == 0:
		bio_price_label.text = "-";
		
	if module_info["price"]["ore"] == 0:
		ore_price_label.text = "-";
		
	if module_info["price"]["gas"] == 0:
		gas_price_label.text = "-";
	
	update_buy_button();
		
	
	
func update_buy_button():
	if selected_module_name == "":
		return;

	if is_bought(selected_module_name):
		buy_button.text = "Bought";
		buy_button.disabled = true;

	elif has_enough_resources(selected_module_name):
		buy_button.text = "Buy";
		buy_button.disabled = false;

	else:
		buy_button.text = "Not enough resources";
		buy_button.disabled = true;
		
	
func _on_Button_pressed():
	# BUY button
	print("BUUUUUUUY");
	buy(selected_module_name);


func buy(module_name):
	if is_bought(module_name):
		return false;
	
	var part = get_part(module_name);
	
	var bought = false;
	
	if has_enough_resources(module_name):
		part.bought_modules[module_name] = true;
		part.set_active_module(module_name);
		var price = module_infos[module_name]["price"];
		Globals.set("bio", Globals.get("bio") - price["bio"]);
		Globals.set("ore", Globals.get("ore") - price["ore"]);
		Globals.set("gas", Globals.get("gas") - price["gas"]);
		bought = true;
		
	select_module(module_name);
	
	if bought:
		hide();


func _on_BodyChain_pressed():
	select_module("BodyChain");


func _on_BodySpider_pressed():
	select_module("BodySpider");


func _on_BodyJet_pressed():
	select_module("BodyJet");


func _on_CollectorBiomass_pressed():
	select_module("CollectorBio");


func _on_CollectorOre_pressed():
	select_module("CollectorOre");


func _on_CollectorGas_pressed():
	select_module("CollectorGas");


func _on_HeadShield_pressed():
	select_module("HeadShield");


func _on_HeadCannon_pressed():
	select_module("HeadCannon");


func _on_HeadCoil_pressed():
	select_module("HeadCoil");


func _on_CloseButton_pressed():
	hide();




func _on_BuyButton_pressed():
	buy(selected_module_name);
