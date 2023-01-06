extends "../Scene.gd";


func _ready():
#	MusicPlayer.play_music("maintheme");
	pass


func _unhandled_input(event):
	if event.is_action("action"):
		_on_StartButton_pressed();


func _on_StartButton_pressed():
	Globals.set("game_ready", false);
	SceneManager.change_scene("res://scenes/02_tutorial/TutorialScene.tscn");


func _on_CreditsButton_pressed():
	SceneManager.change_scene("res://scenes/99_credits/SceneCredits.tscn");


func _on_StartScene_hidden():
	$CanvasLayer.hide();


func _on_StartScene_shown():
	$CanvasLayer.show();


func _on_SettingsButton_pressed():
	MenuPopup.show();

