extends CanvasLayer

@onready var resume_bottom:TextureButton = $ColorRect/VBoxContainer/Resume_buttom
@onready var quit_bottom:TextureButton = $ColorRect/VBoxContainer/Quit_buttom
@onready var animator:AnimationPlayer = $Animation

func _ready():
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		GameMenager.pause_open = true
		animator.play("pause_game")
		get_tree().paused = true
		resume_bottom.grab_focus()


func _on_resume_buttom_pressed():
	animator.play("resume_game")
	get_tree().paused=false
	GameMenager.pause_open = false
	await animator.animation_finished
	visible = false


func _on_quit_buttom_pressed():
	GameMenager.reset()
	get_tree().change_scene_to_file("res://UI/mainMenu.tscn")
