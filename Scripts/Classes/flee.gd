extends State
class_name Flee

const SPEED = 100

@export var character: CharacterBody2D

func _ready():
	enter()

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	character.global_position = character.global_position + Vector2.RIGHT * SPEED * delta
