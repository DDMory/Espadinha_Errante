extends Control

@onready var new_buttom : TextureButton = $VBoxContainer/Nem_Game_Buttom
@onready var quit_buttom : TextureButton = $VBoxContainer/Quit_Game_Buttom

func _ready():
	if GameMenager.pause_open == true:
		get_tree().paused = false
		GameMenager.pause_open == false

func _on_nem_game_buttom_pressed():
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_quit_game_buttom_pressed():
	get_tree().quit()

