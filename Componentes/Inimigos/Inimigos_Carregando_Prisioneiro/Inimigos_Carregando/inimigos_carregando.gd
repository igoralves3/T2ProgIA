extends CharacterBody2D

@onready var SFXDeath = $SFXDeath

signal dead_enemy(myself: CharacterBody2D)

func bullet_hit():
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SFXDeath.play()
	dead_enemy.emit(self)	
	queue_free()
