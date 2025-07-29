extends State
const SPEED = 50
@export var character: CharacterBody2D

@onready var timer: Timer = Timer.new()
var direction: Vector2 = Vector2.DOWN

func _ready():
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	enter()

func _on_timer_timeout():
	var random_value = randi() % 100
	if random_value < 50:
		direction = Vector2.DOWN
	elif random_value < 75:
		direction = Vector2.LEFT
	else:
		direction = Vector2.RIGHT
	timer.start()

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	character.global_position += direction * SPEED * delta
