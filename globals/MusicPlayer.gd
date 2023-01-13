extends AudioStreamPlayer

var current_music_name = "";

# register and preload your music streams here:
const music_streams = {
	"ice": preload("res://music/SpaceHarvesterIce.ogg"),
	"fire": preload("res://music/SpaceHarvesterFire.ogg"),
	"urban": preload("res://music/SpaceHarvesterUrban.ogg"),
	"maintheme": preload("res://music/SpaceHarvesterMaintheme.ogg")
};

func play_music(music_name:String):
	if current_music_name == music_name:
		return;
	
	stop();
	
	current_music_name = music_name;
	stream = music_streams.get(current_music_name);
	
	play();
	
func register_stream(stream_path:String, music_name:String):
	music_streams[music_name] = load(stream_path);
