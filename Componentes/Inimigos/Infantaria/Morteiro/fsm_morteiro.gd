extends State


@export var character: CharacterBody2D
@export var other_player: CharacterBody2D
@export var move_speed: float = 50.0
@export var _animated_sprite: AnimatedSprite2D
@export var item_teste: PackedScene
var destination: Vector2
var infantaria_node
var morteiro_anim

func update_position() -> void:
	var direction = destination - character.global_position
	character.velocity = direction.normalized() * move_speed


func _ready() -> void:
	enter()
func enter() -> void:
	if not other_player:
		get_other_player()
	infantaria_node = get_parent().get_parent()
	morteiro_anim = infantaria_node.get_parent().get_node("Morteiro").get_node("MorteiroAnim")

func get_other_player():
	var currentScene = get_tree().get_current_scene().get_name()
	other_player = get_node('/root/'+currentScene+'/MainPlayerChar')

func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func atirar_morteiro():
	if not other_player:
		get_other_player()
	var distancia =  other_player.global_position - infantaria_node.global_position
	var distancia_normalized = Vector2(distancia.x/224,distancia.y/256).normalized()
	apontar_morteiro(distancia_normalized)
	print (distancia_normalized)
	pass

func apontar_morteiro(distancia_normalized):
	if distancia_normalized.x > 0 and distancia_normalized.x < 0.35:
		morteiro_anim.set_animation("DR0")
	elif distancia_normalized.x > 0.35 and distancia_normalized.x < 0.55:
		morteiro_anim.set_animation("DR1")
	elif distancia_normalized.x > 0.55 and distancia_normalized.x < 0.85:
		morteiro_anim.set_animation("DR2")
	elif distancia_normalized.x > 0.85:
		morteiro_anim.set_animation("DR3")
	elif distancia_normalized.x < 0 and distancia_normalized.x > -0.35:
		morteiro_anim.set_animation("DL0")
	elif distancia_normalized.x < -0.35 and distancia_normalized.x > -0.55:
		morteiro_anim.set_animation("DL1")
	elif distancia_normalized.x < -0.55 and distancia_normalized.x > -0.85:
		morteiro_anim.set_animation("DL2")
	elif distancia_normalized.x < -0.85:
		morteiro_anim.set_animation("DL3")
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Grenade"):
		atirar_morteiro()

#func teste_localizacao(distancia_normalized):
#	var teste = item_teste.instantiate()
#	var position = distancia_normalized * 30
#	teste.position = position + infantaria_node.global_position
#	teste.SPEED = 0

#	get_parent().add_child(teste)
