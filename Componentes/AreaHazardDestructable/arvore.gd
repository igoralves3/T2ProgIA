extends Node2D
@export var isLeft: bool = true
@export_range(0,2) var startFrame: int = 0
@onready var animation = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@export var tocar_animacao: bool = false

func _ready() -> void:
	if isLeft:
		animation.animation = "Left"
		animation.frame = startFrame
		if tocar_animacao:
			animation.play()
	else:
		animation.animation = "Right"
		animation.frame = startFrame
		collision.position = Vector2(-4, collision.position.y)
		if tocar_animacao:
			animation.play()

func grenade_hit():
	queue_free()
