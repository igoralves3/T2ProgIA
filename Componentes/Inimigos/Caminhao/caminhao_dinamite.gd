extends Area2D

class_name Truck

@onready var _animated_sprite = $AnimatedSprite2D
@onready var timer_dinamite = $timer_dinamite
var speed := 0
var max_speed:= 100
@export var other_player: CharacterBody2D
@export var dinamite_packedscene: PackedScene
var offset_do_dinamite = Vector2(-4,18)
@onready var timer_speed = $timer_reset_speed
var saindo: bool = false

func _ready() -> void:
	if not other_player:
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	_animated_sprite.animation_finished.connect(fire_dinamite)
	if other_player.global_position.y < global_position.y:
		queue_free()

func _physics_process(delta: float) -> void:
	position.y += speed * delta * -1
	if other_player:
		var distancia_y = other_player.global_position.y - global_position.y
		if distancia_y < 70:
			speed = max_speed
		elif distancia_y > 150 and not saindo:
			speed = 0

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	_animated_sprite.play("jogando_granada")

func fire_dinamite():
	var dinamite_instance = dinamite_packedscene.instantiate()
	dinamite_instance.position = position + offset_do_dinamite
	dinamite_instance.motion = (other_player.global_position-global_position).normalized()
	get_parent().add_child(dinamite_instance)

func _on_timer_reset_speed_timeout() -> void:
	speed = max_speed
	saindo = true

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('death_normal'):
		body.death_normal()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	timer_speed.start()
	timer_dinamite.start()
	
