extends Area2D

@export var humvee : PackedScene

@export var _timer: Timer
var canSpawn = false
var humvee_exists = null

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	if canSpawn and humvee_exists == null:
		
		var humvee_instance = humvee.instantiate()
		humvee_exists = humvee_instance
		humvee_instance.global_position = Vector2(global_position.x + 40,global_position.y)
		
		get_parent().add_child(humvee_instance)	
		
		#area.add_child(moto)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	canSpawn=true
