class_name Player
extends CharacterBody2D

@export var sword_damage: int = 5

#atributos do proprio "obj" criado
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite_player : Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $DamageArea
@onready var progress_bar_life: ProgressBar = $HealthBar

@export_category("info")
@export var health:int = 15
@export var max_health: int = 15
@export var death_prefab: PackedScene
@export var ritual_damage: int = 1
@export var ritual_Scene: PackedScene
@export var ritual_intervalo: int = 15

@export_category("moviment")
var input_vector:Vector2 = Vector2(0 , 0)
var was_running: bool = false
var is_running: bool = false
var is_Attacking: bool = false
var is_attack_up: bool = false
var is_attack_down: bool = false
@export var speed : float = 3.0

@export_category("cooldown")
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 15.0

signal 	meat_colleted(value:int)

func _ready():
	GameMenager.player = self
	meat_colleted.connect(func(value:int): 
		GameMenager.meat_counter += 1
		)
	
func _process(delta):
	#variavel global para guarda a posição do player
	GameMenager.position_player = position
	
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	
	#cooldown entre ataques
	updateCooldownAttack(delta)
	
	#trocar animação idle == run
	tradeAnimation()
	
	#girar sprite
	spriteFlip()
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	#processar dano
	hitbox_detected(delta)
	
	#ritual
	update_ritual(delta)
	
	#barra de vira
	progress_bar_life.max_value = max_health
	progress_bar_life.value = health
	
func spriteFlip():
	if input_vector.x > 0 && !is_Attacking:
		sprite_player.flip_h=false
	elif input_vector.x < 0 && !is_Attacking:
		sprite_player.flip_h=true
		
func tradeAnimation():
	#trocar animação
	if not is_Attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("Run")
			else:
				animation_player.play("IDLE")
	
func updateCooldownAttack(delta):
	if is_Attacking:
		attack_cooldown -=delta
		if attack_cooldown <= 0.0:
			is_Attacking = false
			is_attack_up = false
			is_attack_down = false
			is_running = false
			animation_player.play("IDLE")

func _physics_process(delta):
	
	#Modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	
	if is_Attacking:
		target_velocity *= 0.25
		
	velocity= lerp(velocity, target_velocity, 0.05)
	move_and_slide()
	
	#Atualizar o is running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func attack():
	if is_Attacking:
		return
	
	#tocar animação
	if input_vector.y < 0:
		is_attack_up = true
		animation_player.play("attack_up_1")
	elif input_vector.y > 0:
		is_attack_down = true
		animation_player.play("attack_down_1")
	else:
		animation_player.play("attack_side_1")
	
	#tempo entra cada ataque	
	attack_cooldown = 0.6
	
	#marcar ataque
	is_Attacking=true;
	
func damage_to_enemy():
	#corpos dentro da area
	var corpos = sword_area.get_overlapping_bodies()
	#para cada 'corpo' em 'corpos'
	for corpo in corpos:
		if corpo.is_in_group("Inimigos"):
			var inimigo:Enemy = corpo
			
			var enemy_direction = (inimigo.position - position).normalized()
			var attack_direction:Vector2
			
			if is_attack_up:
				attack_direction = Vector2.UP
			elif is_attack_down:
				attack_direction = Vector2.DOWN
			elif sprite_player.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			
			var dot_product = enemy_direction.dot(attack_direction)
			if dot_product >= 0.45:
				inimigo.damage(sword_damage)

func damage(dano: int):
	if health <= 0:
		return
	
	health -=dano
	
	#piscar ao tomar dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	
	
	#Foi de F --
	if health <= 0:
		die()

func hitbox_detected(delta:float):
	#temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0:
		return
		
	#frequencia
	hitbox_cooldown = 0.5
	
	var entidades = hitbox_area.get_overlapping_bodies()
	for entity in entidades:
		if entity.is_in_group("Inimigos"):
			var inimigo:Enemy = entity
			var dano = 1
			damage(dano) 

func die():
	GameMenager.end_game()
	
	if death_prefab:
		var death_obj = death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)	
		
	queue_free()

func heal(amount:int):	
	health+=amount
	if health >= max_health:
		return max_health
	else:
		return health

func update_ritual(delta):
	
	ritual_cooldown -=delta
	if ritual_cooldown > 0: 
		return
	
	ritual_cooldown = ritual_intervalo
	
	#criar ritual
	var ritual = ritual_Scene.instantiate()
	ritual.damage = ritual_damage
	add_child(ritual)

