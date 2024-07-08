extends Node

signal game_over 
var position_player: Vector2
var player : Player
var is_game_over: bool = false

var time_elapsed: float = 0.0
var time_elapsed_string: String
var meat_counter: int = 0
var gold_counter: int = 0
var monsters_defeated_counter: int = 0
var pause_open: bool = false

func end_game():
	
	if is_game_over:
		return
	else:
		is_game_over = true
		game_over.emit()
		
func _process(delta):
	time_elapsed +=delta
	var time_elapsed_seconds:int = floori(time_elapsed)
	var seconds: int =  time_elapsed_seconds % 60
	var minutos: int = time_elapsed_seconds / 60
	time_elapsed_string = "%02d:%02d" % [minutos,seconds]

func reset():
	player = null
	position_player = Vector2.ZERO
	is_game_over = false
	time_elapsed = 0.0
	time_elapsed_string = "00:00"
	meat_counter = 0
	gold_counter = 0
	monsters_defeated_counter = 0

	
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
