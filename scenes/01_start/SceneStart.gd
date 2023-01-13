extends "../Scene.gd";

func _ready():
	MusicPlayer.play_music("maintheme");


func _unhandled_input(event):
	if event.is_action("action"):
		_on_StartButton_pressed();


func _on_StartButton_pressed():
	Globals.set("game_ready", false);
	var game_scene = yield(BackgroundLoader.load_scene("res://scenes/03_game/SceneGame.tscn"), "resource_loaded");
	MusicPlayer.stop();
	SceneManager.change_scene(game_scene, { "skip_fade_out": true, "skip_fade_in": true });


func _on_CreditsButton_pressed():
	SceneManager.change_scene("res://scenes/99_credits/SceneCredits.tscn");


func _on_StartScene_hidden():
	$CanvasLayer.hide();


func _on_StartScene_shown():
	$CanvasLayer.show();


func _on_SettingsButton_pressed():
	MenuPopup.show();

