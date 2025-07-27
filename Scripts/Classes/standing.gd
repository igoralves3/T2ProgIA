extends State
const SPEED = 0
@export var character: CharacterBody2D
var other_player: CharacterBody2D
var distancia_pra_fugir: float

func enter() -> void:
	if character.camperando:
		get_parent().get_node("Run").tava_camperando = true
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	character.velocity = Vector2(0,0)
	if not character.camperando:
		await get_tree().process_frame
		transitioned.emit(self,"Run")
	distancia_pra_fugir = randf_range(0, 90)


func exit() -> void:
	if get_parent().get_node("Run").tava_camperando == true:
		character.saindo_da_moita()

func look_at_player() -> Vector2:
	if other_player:
		var player_position = other_player.global_position
		var direction = other_player.global_position - character.global_position
		return direction
	return Vector2.DOWN

func physics_update(delta: float) -> void:
	if character:
		if other_player:
			character.motion_direction = look_at_player().normalized()
			if other_player.global_position.y - character.global_position.y < 25 + distancia_pra_fugir:
				transitioned.emit(self,"Run")
#			character.velocity = movendo_para * move_speed #move_normalized * move_speed
	
