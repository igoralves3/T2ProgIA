extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D

const speed := 100

var dir := 1

@export var other_player: CharacterBody2D

func _ready() -> void:
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if global_position.x > get_viewport().size.x / 2:
		_animated_sprite.flip_h = true
		dir = -1
	_animated_sprite.play("default")

func _physics_process(delta: float) -> void:
	position.x += dir * speed * delta

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('humvee fora')
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print('player colidiu')
		if body.has_method('death_normal'):
			body.death_normal()
