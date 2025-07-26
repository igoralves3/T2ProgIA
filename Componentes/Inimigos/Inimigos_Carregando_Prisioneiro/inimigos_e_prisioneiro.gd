extends Node2D

const SPEED:int = 50

@export var inimigo_esq: CharacterBody2D
@export var prisioneiro: CharacterBody2D
@export var inimigo_dir: CharacterBody2D

@export var other_player: CharacterBody2D

var direction_side := Vector2(-0.7,-1)

var move = false

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_tree().get_first_node_in_group("GrupoPlayer")
	
func _physics_process(delta: float) -> void:
	if inimigo_esq or inimigo_dir:
		if other_player != null:
			var distance = global_position - other_player.global_position
			if distance.length() < 100:
				move = true
				
	elif not inimigo_esq and not inimigo_dir:
		prisioneiro.preso = false
		
	if move and (inimigo_esq or inimigo_dir):
		position.y =position.y - SPEED * delta
				#if global_position.x < other_player.global_position.x:
		position.x =position.x - SPEED * delta
				#elif global_position.x > other_player.global_position.x:
				#	position.x =position.x + SPEED * delta
			
