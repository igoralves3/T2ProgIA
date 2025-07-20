extends State

@export var infantaria_self: CharacterBody2D
@export var other_player: CharacterBody2D
@export var move_speed: float = 50.0
@export var bala_morteiro: PackedScene
@export var morteiro_vfx: PackedScene
var destination: Vector2
#var infantaria_node
var morteiro_anim:  AnimatedSprite2D
var pode_atirar_granada = false
@export var distancia_player_e_fugir = 40
var morteiro_area2d
var offset_da_bala: Vector2
var flip_vfx = false

#func update_position() -> void:
#	var direction = destination - character.global_position
#	character.velocity = direction.normalized() * move_speed

#func _ready() -> void:
#	enter()
func enter() -> void:
	pode_atirar_granada = false
	if not other_player:
		get_other_player()
#	infantaria_node = get_parent().get_parent()
	morteiro_anim = infantaria_self.get_parent().get_node("Morteiro").get_node("MorteiroAnim")
	morteiro_area2d = morteiro_anim.get_parent()

func get_other_player():
	var currentScene = get_tree().get_current_scene().get_name()
	other_player = get_node('/root/'+currentScene+'/MainPlayerChar')

func exit() -> void:
	infantaria_self.pode_atirar = true
	pode_atirar_granada = false
	pass
	
func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if other_player:
		if infantaria_self.global_position.y >= other_player.global_position.y - distancia_player_e_fugir:
			transitioned.emit(self,"Flee")

func fire_grenade():
	atirar_morteiro()
func atirar_morteiro():
#	print ("atirar morteiro")
	if not other_player:
		get_other_player()
	var distancia =  other_player.global_position - infantaria_self.global_position
	var distancia_normalized = Vector2(distancia.x/224,distancia.y/256).normalized()
	apontar_morteiro(distancia_normalized)
	spawn_bala_morteiro()
	pass

func apontar_morteiro(distancia_normalized):
	if distancia_normalized.x > 0 and distancia_normalized.x < 0.35:
		morteiro_anim.set_animation("DR0")
		offset_da_bala = Vector2(4,-7)
		flip_vfx = false
	elif distancia_normalized.x > 0.35 and distancia_normalized.x < 0.55:
		morteiro_anim.set_animation("DR1")
		offset_da_bala = Vector2(5,-8)
		flip_vfx = false
	elif distancia_normalized.x > 0.55 and distancia_normalized.x < 0.85:
		morteiro_anim.set_animation("DR2")
		offset_da_bala = Vector2(6,-9)
		flip_vfx = false
	elif distancia_normalized.x > 0.85:
		morteiro_anim.set_animation("DR3")
		offset_da_bala = Vector2(7,-10)
		flip_vfx = false
	elif distancia_normalized.x < 0 and distancia_normalized.x > -0.35:
		morteiro_anim.set_animation("DL0")
		offset_da_bala = Vector2(-4,-7)
		flip_vfx = true
	elif distancia_normalized.x < -0.35 and distancia_normalized.x > -0.55:
		morteiro_anim.set_animation("DL1")
		offset_da_bala = Vector2(-5,-8)
		flip_vfx = true
	elif distancia_normalized.x < -0.55 and distancia_normalized.x > -0.85:
		morteiro_anim.set_animation("DL2")
		offset_da_bala = Vector2(-6,-9)
		flip_vfx = true
	elif distancia_normalized.x < -0.85:
		morteiro_anim.set_animation("DL3")
		offset_da_bala = Vector2(-7,-10)
		flip_vfx = true
	pass

func spawn_bala_morteiro():
	var bala = bala_morteiro.instantiate()
	var vfx = morteiro_vfx.instantiate()
	bala.objeto_alvo = other_player
	bala.position = morteiro_area2d.position + offset_da_bala
	vfx.position = morteiro_area2d.position + offset_da_bala
	vfx.flip_horizontal = flip_vfx
	infantaria_self.get_parent().add_child(bala)
	infantaria_self.get_parent().add_child(vfx)
	#morteiro_area2d.add_child(bala)
	#morteiro_area2d.add_child(vfx)
	pass

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("Grenade"):
#		spawn_bala_morteiro()
#		atirar_morteiro()
