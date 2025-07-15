extends CharacterBody2D

@onready var SFXDeath = $SFXDeath


@onready var _animated_sprite:= $AnimatedSprite2D

signal dead_enemy(myself: CharacterBody2D)

func _ready() -> void:
	_animated_sprite.play("default")

func bullet_hit():
	set_collision_layer_value(3, false)
	$Area2DColisaoMorte.set_collision_layer_value(3, false)
	SFXDeath.play()
	dead_enemy.emit(self)	
	queue_free()
