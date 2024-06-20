class_name GameOverUI
extends CanvasLayer

@onready var time_label : Label = %Time
@onready var monster_label : Label = %monsters
@onready var gold_label : Label = %gold
@onready var restart_buttom : TextureButton = $VBoxContainer2/TextureButton
@onready var quit_buttom : TextureButton = $VBoxContainer2/TextureButton2

func _ready():
	time_label.text = GameMenager.time_elapsed_string
	monster_label.text = str(GameMenager.monsters_defeated_counter)
	gold_label.text = str(GameMenager.gold_counter)
	
func _on_texture_button_pressed():
	restart_game()
	

func restart_game():
	GameMenager.reset()
	get_tree().reload_current_scene()

func _on_texture_button_2_pressed():
	get_tree().quit()
