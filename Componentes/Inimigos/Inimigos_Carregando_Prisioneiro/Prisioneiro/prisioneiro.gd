extends CharacterBody2D


@export var preso = true


@onready var _animated_sprite := $AnimatedSprite2D


func _process(delta: float) -> void:
	if preso:
		_animated_sprite.play("preso")
	else:
		_animated_sprite.play("livre")
