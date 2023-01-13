# BODY
extends HarvesterPart

onready var modules = $Modules.get_children();
onready var active_module = $Modules/BodyChain;
var is_ready = false;
var harvester: Harvester;

var bought_modules = {
	"BodyChain": true,
	"BodySpider": false,
	"BodyJet": false
};

func _ready():
	width = 400;
	height = 200;
	
	for module in modules:
		if module != active_module:
			module.visible = false;
		else:
			module.visible = true;
	
		
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");
	
	is_ready = true;

func _on_Body_selected():
	if not $ModuleChooserPopup.visible:
		$ModuleChooserPopup.popup();

func _on_Body_deselected():
	if $ModuleChooserPopup.visible:
		$ModuleChooserPopup.hide();


func _on_ModuleChooser_module_chosen(module_name):
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
