extends Sprite

export var own_speed_factor = -100.0;

var tween: Tween;

var original: Sprite;
var copy: Sprite;

var width: int = 0;
var original_position = 0;

var harvester;

func _ready():
	if Globals.get("game_ready") != true:
		yield(SceneManager, "scene_loaded");
		
	harvester = SceneManager.get_entity("Harvester");
	
	original_position = position.x;
	width = texture.get_width();
	
	copy = Sprite.new();
	copy.texture = texture;
	copy.centered = false;
	add_child(copy);
	copy.position.x = width;
	copy.position.y = 0;

func _process(delta):
	if global_position.x < -width:
		global_position.x += width;
	
	global_position.x += (own_speed_factor / 100) * harvester.speed * delta;
	
#
#func adjust_speed(_speed, _base_speed):
#	var speed_factor = get_speed_factor();
#	var remaining_time = tween.get_runtime();
#
#	if speed_factor == 0:
#		tween.stop_all();
#	else:
#		var transform_factor = current_speed_factor / speed_factor;
#		print("adjust speed ", speed_factor,", ",  remaining_time, ",", transform_factor);
#
#		if tween.is_inside_tree():
#			tween.stop_all();
#			tween.remove_all();
#			tween.interpolate_property(self, "position:x", position.x, -width, remaining_time * transform_factor, Tween.TRANS_LINEAR);
#			tween.start();
#
#		current_speed_factor = speed_factor;
