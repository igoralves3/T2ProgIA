extends Node2D

@export var moto_scene: PackedScene
@export var limite_de_inimigos: int = 1
#@export var area: Node
@export var timer: Timer

var moto_exists = null
var ListaInimigos: Array
var canSpawn = false

func _ready() -> void:
	pass
	


func _on_timer_timeout() -> void:
	if canSpawn and moto_exists == null:
		
		var moto = moto_scene.instantiate()
		moto_exists = moto
		moto.global_position = Vector2(global_position.x + 20,global_position.y)
		
		get_parent().add_child(moto)	
		
		#area.add_child(moto)
			


func _on_area_entered(area: Area2D) -> void:
	pass
		


func _on_body_entered(body: Node2D) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	canSpawn = true
