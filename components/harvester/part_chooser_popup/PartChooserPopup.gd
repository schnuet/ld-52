extends PopupPanel

signal part_chosen;

export var prev_position = Vector2(0, 0);
export var next_position = Vector2(0, 0);
export var button_size = Vector2(40, 40);

var selected_part_index = 0;
var previous_selected_part_index = null;

var direction = -1;
var tween: Tween;
var animation_time = 0.2;

var parts = [];

onready var prev_button = $HBoxContainer/Prev;
onready var next_button = $HBoxContainer/Next;

onready var parent: HarvesterPart = get_parent();

func _ready():
	tween = Tween.new();
	add_child(tween);
	
	prev_button.rect_position.x = prev_position.x - button_size.x;
	prev_button.rect_position.y = prev_position.y - button_size.y / 2;
	next_button.rect_position.x = next_position.x;
	next_button.rect_position.y = next_position.y - button_size.y / 2;
	
	# collect parts
	var children = get_children();
	for child in children:
		if child.is_in_group("part"):
			parts.append(child);
	
	for part in parts:
		part.visible = false;
		remove_child(part);
		$HBoxContainer/MarginContainer.add_child(part);
	
	update_selected_part();
	
func _process(delta):
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


func get_selected_part():
	return parts[selected_part_index];

func update_selected_part():
	tween.stop_all();
	tween.remove_all();
	# tween.disconnect("tween_all_completed", );
	
	if previous_selected_part_index != null:
		var previous_part = parts[previous_selected_part_index];
		previous_part.visible = false;
		tween.interpolate_property(previous_part, "position:x", 0, 200 * direction, animation_time);
		tween.interpolate_property(previous_part, "modulate", previous_part.modulate, Color.transparent, animation_time);
		print("tween previous", previous_part.modulate);
		# tween.interpolate_property(previous_part, "visible", true, false, animation_time);
	
	var selected_part = get_selected_part();
	selected_part.visible = true;
	var _tw1 = tween.interpolate_property(selected_part, "position:x", 200 * -direction, 0, animation_time);
	var _tw2 = tween.interpolate_property(selected_part, "modulate", selected_part.modulate, Color.white, animation_time);
	
	var _tw3 = tween.start();

func swipe_left():
	direction = -1;
	if selected_part_index == 0:
		previous_selected_part_index = selected_part_index;
		selected_part_index = parts.size() - 1;
	else:
		previous_selected_part_index = selected_part_index;
		selected_part_index = selected_part_index - 1;
		
	update_selected_part();

func swipe_right():
	direction = 1;
	if selected_part_index >= parts.size() - 1:
		previous_selected_part_index = selected_part_index;
		selected_part_index = 0;
	else:
		previous_selected_part_index = selected_part_index;
		selected_part_index = selected_part_index + 1;
	
	print("selected part", selected_part_index);
	
	update_selected_part();


func _on_Prev_pressed():
	swipe_left();


func _on_Next_pressed():
	swipe_right();


func _on_PartChooserPopup_popup_hide():
	var game = SceneManager.get_entity("Game");
	game.select_part(null);
	
	var selected_part = get_selected_part();
	emit_signal("part_chosen", selected_part.name);
