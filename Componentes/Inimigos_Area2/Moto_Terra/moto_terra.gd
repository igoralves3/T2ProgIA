extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D
@export var other_player: CharacterBody2D
const slow_speed := 100
var cur_speed:= slow_speed
var dir := 1

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	if global_position.x > get_viewport_rect().size.x / 2:
		_animated_sprite.flip_h = true
		dir = -1
	_animated_sprite.play('default')

func _physics_process(delta: float) -> void:
	position.x += dir * cur_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('death_normal'):
		body.death_normal()
