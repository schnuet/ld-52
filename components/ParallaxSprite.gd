extends Sprite

export var time = 30;

var tween: Tween;

var original: Sprite;
var copy: Sprite;

var width: int = 0;
var original_position = 0;

func _ready():
	original_position = position.x;
	width = texture.get_width();
	
	copy = Sprite.new();
	copy.texture = texture;
	copy.centered = false;
	add_child(copy);
	copy.position.x = width;
	copy.position.y = 0;
	
	tween = Tween.new();
	tween.connect("tween_all_completed", self, "restart_tween");
	add_child(tween);
	restart_tween();

func restart_tween():
	position.x = 0;
	
	tween.remove_all();
	tween.interpolate_property(self, "position:x", position.x, -width, time);
	tween.start();
