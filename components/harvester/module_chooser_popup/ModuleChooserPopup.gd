extends PopupPanel

signal module_chosen(module_name);

export var button_size = Vector2(40, 40);

var selected_module_index = 0;
var previous_selected_module_index = null;

var direction = -1;
var tween: Tween;
var animation_time = 0.2;

var modules = [];
var available_modules = [];

onready var prev_button = $HBoxContainer/CenterContainer/Prev;
onready var next_button = $HBoxContainer/CenterContainer2/Next;

onready var parent: HarvesterPart = get_parent();

var is_ready = false;


# button textures
# PREV
var button_prev_textures = {
	"blue": {
		"normal": preload("res://assets/arrows/blue/arrow_left_blue.PNG"),
		"disabled": preload("res://assets/arrows/grey/arrow_left_disabled.PNG"),
		"hover": preload("res://assets/arrows/blue/arrow_left_hover_blue.PNG"),
		"pressed": preload("res://assets/arrows/blue/arrow_left_click_blue.PNG")
	},
	"red": {
		"normal": preload("res://assets/arrows/red/arrow_left_red.PNG"),
		"disabled": preload("res://assets/arrows/grey/arrow_left_disabled.PNG"),
		"hover": preload("res://assets/arrows/red/arrow_left_hover_red.PNG"),
		"pressed": preload("res://assets/arrows/red/arrow_left_click_red.PNG")
	},
	"yellow": {
		"normal": preload("res://assets/arrows/yellow/arrow_left_yellow.PNG"),
		"disabled": preload("res://assets/arrows/grey/arrow_left_disabled.PNG"),
		"hover": preload("res://assets/arrows/yellow/arrow_left_hover_yellow.PNG"),
		"pressed": preload("res://assets/arrows/yellow/arrow_left_click_yellow.PNG")
	}
};
var button_next_textures = {
	"blue": {
		"normal": preload("res://assets/arrows/blue/arrow_right_blue.PNG"),
		"disabled": preload("res://assets/arrows/grey/arrow_right_disabled.PNG"),
		"hover": preload("res://assets/arrows/blue/arrow_right_hover_blue.PNG"),
		"pressed": preload("res://assets/arrows/blue/arrow_right_click_blue.PNG")
	},
	"red": {
		"normal": preload("res://assets/arrows/red/arrow_right_red.PNG"),
		"disabled": preload("res://assets/arrows/grey/arrow_right_disabled.PNG"),
		"hover": preload("res://assets/arrows/red/arrow_right_hover_red.PNG"),
		"pressed": preload("res://assets/arrows/red/arrow_right_click_red.PNG")
	},
	"yellow": {
		"normal": preload("res://assets/arrows/yellow/arrow_right_yellow.PNG"),
		"disabled": preload("res://assets/arrows/grey/arrow_right_disabled.PNG"),
		"hover": preload("res://assets/arrows/yellow/arrow_right_hover_yellow.PNG"),
		"pressed": preload("res://assets/arrows/yellow/arrow_right_click_yellow.PNG")
	}
};

func _ready():
	tween = Tween.new();
	add_child(tween);
	
	if not parent.is_ready:
		yield(parent, "ready");
	
	# collect parts
	var children = get_children();
	for child in children:
		if child.is_in_group("module"):
			modules.append(child);
	
	for module in modules:
		module.visible = false;
		remove_child(module);
		$HBoxContainer/MarginContainer.add_child(module);
	
	update_available_modules();
	update_selected_module();
	
	is_ready = true;
	
func _process(_delta):
	if not visible:
		return;
	update_position();

func update_position():
	rect_size.x = parent.width + button_size.x * 2;
	rect_size.y = parent.height;
	rect_position.x = parent.global_position.x - rect_size.x / 2;
	rect_position.y = parent.global_position.y - rect_size.y / 2;
	
	var m_cont = $HBoxContainer/MarginContainer;
	m_cont.rect_min_size.x = parent.width;
	m_cont.rect_min_size.y = parent.height;
	
	for child in m_cont.get_children():
		child.position.x = parent.width / 2;
		child.position.y = parent.height;


func get_selected_module() -> Node2D:
	return available_modules[selected_module_index];

func update_selected_module():
	pass
#	tween.stop_all();
#	tween.remove_all();
#	# tween.disconnect("tween_all_completed", );
#
#	if previous_selected_module_index != null:
#		var previous_part = available_modules[previous_selected_module_index];
#		previous_part.visible = false;
#
#	var selected_module = get_selected_module();
#	selected_module.visible = true;
#	selected_module.module = Color.transparent;
#	# var _tw2 = tween.interpolate_property(selected_module, "modulate", selected_module.modulate, Color.white, animation_time);
#
#	var _tw3 = tween.start();

func swipe_left():
	direction = -1;
	if selected_module_index == 0:
		previous_selected_module_index = selected_module_index;
		selected_module_index = available_modules.size() - 1;
	else:
		previous_selected_module_index = selected_module_index;
		selected_module_index = selected_module_index - 1;
		
	update_selected_module();
	
	var selected_module = get_selected_module();
	emit_signal("module_chosen", selected_module.name);

func swipe_right():
	direction = 1;
	if selected_module_index >= available_modules.size() - 1:
		previous_selected_module_index = selected_module_index;
		selected_module_index = 0;
	else:
		previous_selected_module_index = selected_module_index;
		selected_module_index = selected_module_index + 1;
	
	update_selected_module();
	
	var selected_module = get_selected_module();
	emit_signal("module_chosen", selected_module.name);


func _on_Prev_pressed():
	swipe_left();


func _on_Next_pressed():
	swipe_right();


func _on_PartChooserPopup_popup_hide():
	var selected_module = get_selected_module();
	emit_signal("module_chosen", selected_module.name);

func update_available_modules():
	available_modules = [];
	var real_active_module = parent.active_module;
	
	print(parent.name);
	
	var i = 0;
	for module in modules:
		if parent.bought_modules.get(module.name) == true:
			available_modules.append(module);
			
			if module.name == real_active_module.name:
				selected_module_index = available_modules.size() - 1;
		
		i += 1;
	
	if available_modules.size() <= 1:
		prev_button.disabled = true;
		next_button.disabled = true;
	else:
		prev_button.disabled = false;
		next_button.disabled = false;

func _on_ModuleChooserPopup_about_to_show():
	update_available_modules();
	update_arrow_colors();
	
	prev_button.focus_mode = Control.FOCUS_NONE;
	next_button.focus_mode = Control.FOCUS_NONE;



func update_arrow_colors():
	var theme_color = Globals.get("theme_color");
	prev_button.texture_normal = button_prev_textures[theme_color]["normal"];
	prev_button.texture_disabled = button_prev_textures[theme_color]["disabled"];
	prev_button.texture_hover = button_prev_textures[theme_color]["hover"];
	prev_button.texture_pressed = button_prev_textures[theme_color]["pressed"];
	prev_button.texture_focused = button_prev_textures[theme_color]["hover"];
	
	next_button.texture_normal = button_next_textures[theme_color]["normal"];
	next_button.texture_disabled = button_next_textures[theme_color]["disabled"];
	next_button.texture_hover = button_next_textures[theme_color]["hover"];
	next_button.texture_pressed = button_next_textures[theme_color]["pressed"];
	next_button.texture_focused = button_next_textures[theme_color]["hover"];
