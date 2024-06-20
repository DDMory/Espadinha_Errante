extends Node	

@export var speed = 1.0

var enemy: Enemy
var sprite: AnimatedSprite2D 

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	
func _physics_process(delta):
	# GameOver
	if GameMenager.is_game_over == true: return
	
	#calcular direção
		#posição do player
	var position_player = GameMenager.position_player
	var diference = position_player - enemy.position
	var input_vector = diference.normalized()
	
	#movimento
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
	
	#Girar o sprite
	if input_vector.x > 0:
		sprite.flip_h=false
	elif input_vector.x < 0:
		sprite.flip_h=true
