extends Node2D
@export var isLeft: bool = true
@export var startFrame: int = 0
@onready var animation = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

func _ready() -> void:
	if isLeft:
		animation.animation = "Left"
		animation.frame = startFrame
		animation.play()
	else:
		animation.animation = "Right"
		animation.frame = startFrame
		animation.play()
		collision.position = Vector2(-4, collision.position.y)
