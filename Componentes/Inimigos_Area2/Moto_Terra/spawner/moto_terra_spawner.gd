extends Area2D


@export var moto_terra : PackedScene

@export var _timer: Timer
var canSpawn = false
var moto_terra_exists = null

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	if canSpawn and moto_terra_exists == null:
		
		var moto = moto_terra.instantiate()
		moto_terra_exists = moto
		moto.global_position = Vector2(global_position.x + 40,global_position.y)
		
		get_parent().add_child(moto)	
		
		#area.add_child(moto)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	canSpawn=true
