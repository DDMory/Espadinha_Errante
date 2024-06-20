extends AnimatedSprite2D

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
func on_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		GameMenager.gold_counter += 20
		queue_free()
