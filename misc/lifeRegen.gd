extends Node2D

@export var Rege_Amount: int = 2

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
func on_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		var player:Player = body 
		player.heal(Rege_Amount)
		player.meat_colleted.emit(Rege_Amount)
		queue_free()
