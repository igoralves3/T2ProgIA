extends State
const SPEED = 0
@export var character: CharacterBody2D
var other_player: CharacterBody2D
var distancia_pra_fugir: float
var trocar_de_fsm: bool = false

func enter() -> void:
	if not character.camperando:
		trocar_de_fsm = true
	if character.camperando:
		get_parent().get_node("Run").tava_camperando = true
	if not other_player:
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	character.velocity = Vector2(0,0)
	distancia_pra_fugir = randf_range(0, 90)

func exit() -> void:
	if get_parent().get_node("Run").tava_camperando == true:
		character.saindo_da_moita()

func look_at_player() -> Vector2:
	if other_player:
		var direction = other_player.global_position - character.global_position
		return direction
	return Vector2.DOWN

func physics_update(_delta: float) -> void:
	if character:
		if other_player:
			character.motion_direction = look_at_player().normalized()
			if other_player.global_position.y - character.global_position.y < 25 + distancia_pra_fugir:
				transitioned.emit(self,"Run")
	if trocar_de_fsm:
				transitioned.emit(self,"Run")
	
