extends CharacterBody2D

@export var vida: int
@export var type: String
@export var speed: int = 100
@onready var pontos: int = 200
@export var fireRate: float
@export var alvo: CharacterBody2D

func _physics_process(delta: float) -> void:
	move_and_slide()
