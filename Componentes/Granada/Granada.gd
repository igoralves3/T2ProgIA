extends CharacterBody2D

class_name  Grenade
@export var motion := Vector2(0,0)

const SPEED = 90.0

var frames : float = 0.0

const maxFrames = 60

func _ready():
	print('grenade')
	
func _physics_process(delta: float) -> void:
	frames = frames + 1
	if frames >= maxFrames:
		#explosão da granada
		print('grenade end')
		queue_free()
	
	position += motion * SPEED * delta
	
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	queue_free()
