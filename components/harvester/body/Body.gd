# BODY
extends HarvesterPart

signal speed_changed;

var base_speed = 200;
var speed = base_speed;

func _ready():
	width = 400;
	height = 200;

func set_speed(value: int):
	speed = value;
	emit_signal("speed_changed", speed, base_speed);

func _on_Body_selected():
	$PartChooser.popup();

func _on_Body_deselected():
	if $PartChooser.visible:
		$PartChooser.hide();


func _on_PartChooser_part_chosen():
	pass # Replace with function body.
