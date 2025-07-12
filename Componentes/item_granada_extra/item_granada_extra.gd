extends Area2D

class_name GranadaExtra

@export var grenadeBonus = 1

@export var grenade1_spr : Texture
@export var grenade3_spr : Texture
@export var grenade5_spr : Texture

@onready var sprite = $Sprite2D

func _ready() -> void:
	if grenadeBonus == 1:
		sprite.texture = grenade1_spr
	elif grenadeBonus == 3:
		sprite.texture = grenade3_spr
	elif grenadeBonus == 5:
		sprite.texture = grenade5_spr
	else:
		grenadeBonus = 1
		sprite.texture = grenade1_spr

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print('coletou granada')
		body.grenadeAmmo =body.grenadeAmmo + grenadeBonus
		print('granadas: '+str(body.grenadeAmmo))
		queue_free()
	else:
		print('nao coletou')
