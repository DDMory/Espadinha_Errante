extends CanvasLayer

@onready var timer_label: Label = %game_time
@onready var meat_label: Label = %meat_count
@onready var gold_label: Label = %gold_count

func _process(delta):
	meat_label.text = str(GameMenager.meat_counter)
	gold_label.text = str(GameMenager.gold_counter)
	timer_label.text = GameMenager.time_elapsed_string


