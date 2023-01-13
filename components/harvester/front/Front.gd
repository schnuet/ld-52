# FRONT
extends HarvesterPart;

onready var active_module = $Modules/CollectorBio;
var is_ready = false;

var harvester;

var bought_modules = {
	"CollectorBio": true,
	"CollectorOre": false,
	"CollectorGas": false
};
onready var modules = $Modules.get_children();

func _ready():
	width = 300;
	height = 200;
	
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");

	is_ready = true;
	
	for module in modules:
		module.deactivate();
	
	active_module.activate();
	

func _on_Front_selected():
	if not $ModuleChooserPopup.visible:
		$ModuleChooserPopup.popup();

func _on_Front_deselected():
	if $ModuleChooserPopup.visible:
		$ModuleChooserPopup.hide();


func _on_ModuleChooserPopup_module_chosen(module_name):
	set_active_module(module_name);
	
func set_active_module(module_name):
	if active_module.name == module_name:
		return;
		
	print("module chosen ", module_name);
	var module = $Modules.get_node(module_name);
	active_module.visible = false;
	
	if active_module.has_method("deactivate"):
		active_module.deactivate();
		
	active_module = module;
	active_module.visible = true;
	module.activate();
	
	harvester.update_animated_sprite();
