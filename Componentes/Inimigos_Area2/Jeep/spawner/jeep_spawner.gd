extends Area2D

@export var jeep : PackedScene

@onready var _timer = $Timer
var canSpawn = false
var jeep_exists = null

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if canSpawn and jeep_exists == null:
		
		var jeep_instance = jeep.instantiate()
		jeep_exists = jeep_instance
		jeep_instance.global_position = Vector2(global_position.x + 40,global_position.y)
		
		get_parent().add_child(jeep_instance)	

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	canSpawn=true
