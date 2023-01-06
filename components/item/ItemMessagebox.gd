extends "res://components/item/Item.gd"

func interact(player):
	yield(MessageBox.show_message("player", "hi there"), "done");
