extends Area2D

const SPEED := 100

@onready var _animated_sprite = $AnimatedSprite2D

@export var dir:= Vector2.ZERO

func _ready():
	if dir.x < 0:
		_animated_sprite.play('L2')
	elif dir.x > 0:
		_animated_sprite.play('D2')
	else:
		_animated_sprite.play('reto')

func _physics_process(delta: float) -> void:
	position = position + dir *SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('tiro bazooka fora')
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is InfantariaBazooka:
		return
	set_collision_mask_value(2, false) #tirar colisao inimigo
	
#	print (body, "player bullet hit")
	if body.has_method("death_normal"):
		body.death_normal()
	#await get_tree().create_timer(tempo_animacao).timeout
	queue_free()
