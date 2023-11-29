extends Node2D


func _on_start_button_pressed():
	Board.instance.start_game()


func _on_reset_button_pressed():
	get_tree().change_scene_to_file("res://screen/world.tscn")
