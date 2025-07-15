extends Node2D

const SPEED:int = 100

@export var inimigo_esq: CharacterBody2D
@export var prisioneiro: CharacterBody2D
@export var inimigo_dir: CharacterBody2D

@export var other_player: CharacterBody2D

func _ready():
	if not other_player:
		var currentScene = get_tree().get_current_scene().get_name()
		other_player = get_node('/root/'+currentScene+'/MainPlayerChar')
	
func _physics_process(delta: float) -> void:
	if inimigo_esq or inimigo_dir:
		var distance = global_position - other_player.global_position
		if distance.length() < 100:
			position.y =position.y - SPEED * delta
			if global_position.x < other_player.global_position.x:
				position.x =position.x - SPEED * delta
			elif global_position.x > other_player.global_position.x:
				position.x =position.x + SPEED * delta
			
