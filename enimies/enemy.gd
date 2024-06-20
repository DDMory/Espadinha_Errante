class_name Enemy
extends Node2D

@onready var damage_digit_marker = $Damage_Digit_Marker

@export_category("Life && Damage")
@export var health:int = 10
@export var death_prefab: PackedScene

var damage_digit_prefab: PackedScene

@export_category("drops")
@export var percent_drop: float = 0.5
@export var drop_items: Array[PackedScene]
@export var drop_chances: 	Array[float]

func _ready():	
	damage_digit_prefab = preload("res://misc/damageDigit.tscn")

func damage(dano: int):
	if health <= 0:
		return
		
	health -=dano
	
	#criar damage digit
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = dano
	
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position
	get_parent().add_child(damage_digit)
	
	#piscar ao tomar dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	
	#Foi de F --
	if health <= 0:
		die()

func die():
	if death_prefab:
		var death_obj = death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)	
		
	#drop
	if randf() <= percent_drop:
		drop_item()
		
	#incrementar contador
	GameMenager.monsters_defeated_counter += 1
		
	queue_free()

#@export var percent_drop: float = 0.25
#@export var drop_items: Array[PackedScene]
func drop_item():
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func get_random_drop_item():
	#lista de 1 item
	if drop_items.size() == 1:
		return drop_items[0]
	
	#calcular chance maxima
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	
	#jogar dado
	var random_result = randf() * max_chance
	
	#girar roleta
	var needle:float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		
		if random_result <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	
	return drop_items[0]
