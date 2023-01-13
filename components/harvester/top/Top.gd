# TOP
extends HarvesterPart;

onready var active_module = $Modules/HeadShield;
var is_ready = false;

var bought_modules = {
	"HeadShield": true,
	"HeadCannon": false,
	"HeadCoil": false
};

var harvester: Harvester;

func _ready():
	width = 400;
	height = 200;
	
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");
	
	is_ready = true;

func _on_ModuleChooserPopup_module_chosen(module_name):
	set_active_module(module_name);

func set_active_module(module_name):
	print("module chosen ", module_name);
	var module = $Modules.get_node(module_name);
	active_module.visible = false;
	
	if active_module.has_method("deactivate"):
		active_module.deactivate();
	
	active_module = module;
	active_module.visible = true;
	
	if module.has_method("activate"):
		module.activate();
	
	harvester.update_animated_sprite();


func _on_Top_deselected():
	if $ModuleChooserPopup.visible:
		$ModuleChooserPopup.hide();


func _on_Top_selected():
	if not $ModuleChooserPopup.visible:
		$ModuleChooserPopup.popup();


