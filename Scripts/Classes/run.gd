extends State
var move_speed = 50
@export var character: CharacterBody2D
var other_player: CharacterBody2D
var tava_camperando: bool = false
var recem_spawned: bool = true #recem spawned pelo enemy spawner

func _ready():
	pass

func enter() -> void: #chamar primeiro movimento se camperando  ou nao
	if not other_player:
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	update_movimento()

func exit() -> void:
	pass

func pegar_prox_motion():
	var proximo_movimento
	if not tava_camperando and not recem_spawned:
		proximo_movimento = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	elif tava_camperando:
		proximo_movimento = Vector2(0,-1)
		tava_camperando = false
	elif recem_spawned:
		proximo_movimento = Vector2(sign(other_player.global_position.x - character.global_position.x),0)
		recem_spawned = false
	return proximo_movimento

func update_movimento():
	var movendo_para:= Vector2(0,0)
	if character:
		if other_player:
			movendo_para = pegar_prox_motion()
			character.velocity = movendo_para * move_speed
			character.motion_direction = movendo_para
	
