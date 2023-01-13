extends Scene

func _ready():
	Globals.set("game_ready", false);
	pass
	

func _on_RestartButton_pressed():
	SceneManager.change_scene("res://scenes/01_start/SceneStart.tscn");


