class_name MobSpawner

extends Node2D

@onready var path_follow : PathFollow2D = %PathFollow2D
@export var monsters : Array[PackedScene]

var mobs_per_min: float = 60.0
var spawn_cooldown: float

func _process(delta:float):	
	#player está morto
	if GameMenager.is_game_over == true: return
	
	#temporizador
	spawn_cooldown -=delta
	if spawn_cooldown > 0: 
		return
	
	#Frequencia
	var intervalo = 60.0 / mobs_per_min
	spawn_cooldown = intervalo
	
	#checar se ponto é valido
	var point = get_point()
	var world_State = get_world_2d().direct_space_state
	var parametros = PhysicsPointQueryParameters2D.new()
	parametros.position = point
	parametros.collision_mask = 0b1000
	
	#perguntar se tem algo
	var resultado:Array = world_State.intersect_point(parametros, 1)
	if not resultado.is_empty(): return
	
	#instanciar criatura aleatoria
	var index = randi_range(0 , monsters.size() - 1)
	var monster_scene = monsters[index]
	var monster = monster_scene.instantiate()
	monster.global_position = point
	get_parent().add_child(monster)
	
func get_point():
	path_follow.progress_ratio = randf()
	return path_follow.global_position
