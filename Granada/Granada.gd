extends CharacterBody2D

class_name  Granade
@export var motion := Vector2(0,0)

const SPEED = 90.0

var frames : float = 0.0

const maxFrames = 60

func _ready():
	print('granade')
	
func _physics_process(delta: float) -> void:
	frames = frames + 1
	if frames >= maxFrames:
		#explosão da granada
		print('granade end')
		queue_free()
	
	position += motion * SPEED * delta
	
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	queue_free()
