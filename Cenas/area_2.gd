extends Node2D

@onready var camera = %Camera2D
@onready var player = %MainPlayerChar
var posicao_player: Vector2
var posicao_camera: Vector2
var camera_distancia_y_minima = 170
var camera_altura_maxima_y = -1791.5

var currentCheckpoint: Vector2
#@onready var startPoint: Vector2 = Vector2(74,100)

func _ready() -> void:
	GameManager.setStartPoint(player.global_position)
	GameManager.currentScene = "res://Cenas/area2/Area_2.tscn"
	%MainPlayerChar.global_position = GameManager.getSpawnPostion()

func _process(delta: float) -> void:
#	print (camera.offset.y, "offset")
#	print (camera.position.y, "position")
	if player.position.y - camera.offset.y < camera_distancia_y_minima and camera.offset.y >= camera_altura_maxima_y:
		camera.offset.y = player.position.y -camera_distancia_y_minima
	#player camera.offset 

func next_level():
	GameManager.addMedals()

func _on_main_player_char_dead_player():
	GameManager.reduceLifes()
