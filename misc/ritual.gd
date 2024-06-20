extends Node2D

@export var damage : int = 1
@onready var area: Area2D = $Area2D

func deal_damage():
	var corpos = area.get_overlapping_bodies()
	for corpo in corpos:
		if corpo.is_in_group("Inimigos"):
			var inimigo: Enemy = corpo
			inimigo.damage(damage)
	
