extends Node

@export var mob_spawner: MobSpawner
@export var mob_rate_per_minut: float = 60.0
@export var inicial_spawn_rate: float  = 55.0
@export var wave_direction : float = 20.0
@export var break_intesidade : float = 0.5

var time:float = 0.0

func _process(delta):
	#jogador esta morto ?
	if GameMenager.is_game_over == true: return
	
	time += delta
	
	#dificuldade linear (linha verde)
	var spawm_rate = inicial_spawn_rate + mob_rate_per_minut * ( time / 60.0 )
	
	#sistema de ondas (linhar osa)
	var wave = sin( ( time * TAU ) / wave_direction)
	var wave_factor = remap(wave, -1.0, 1.0, break_intesidade, 1)
	spawm_rate *= wave_factor
	
	#aplicar dificuldade
	mob_spawner.mobs_per_min = spawm_rate
	
