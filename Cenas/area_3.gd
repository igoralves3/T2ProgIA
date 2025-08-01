extends Node2D

@onready var camera = %Camera2D
@onready var player = %MainPlayerChar
@onready var spawnIncial = $Marker2D
var posicao_player: Vector2
var posicao_camera: Vector2
var camera_distancia_y_minima = 170
var camera_altura_maxima_y = -1791.5
@export var musica_inicial: AudioStream
@export var musica_intermission: AudioStream
@export var musica_retry: AudioStream
@export var musica_fortress: AudioStream
var currentCheckpoint: Vector2
var finalStage = false
var finalMobsCount: int

# area 3 spawna nas casinhas assim que o player nasce e o max é 5 inimigos

func _ready() -> void:
	GameManager.setStartPoint(spawnIncial.global_position)
	GameManager.currentScene = "res://Cenas/Area_1.tscn"
	%MainPlayerChar.global_position = GameManager.getSpawnPostion()

func _process(delta: float) -> void:
	finalMobsCount = get_tree().get_nodes_in_group("FinalMobs").size()
	if player.position.y - camera.offset.y < camera_distancia_y_minima and camera.offset.y >= camera_altura_maxima_y:
		camera.offset.y = player.position.y -camera_distancia_y_minima
	
	if finalStage and finalMobsCount == 0:
		next_level()

func next_level():
	print("Voce venceu!")
	finalStage = false
	GameManager.addMedals()
	GameManager.hasCheckpoint = false
	#get_tree().root.get_node("Game").change_scene("res://Cenas/Area_2.tscn")
	get_tree().root.get_node("Game").change_scene("res://Cenas/Intermissions/intermission_1.tscn")

func _on_main_player_char_dead_player():
	GameManager.reduceLifes()
	get_tree().root.get_node("Game").change_scene("res://Cenas/Preload/preload.tscn")
	#get_tree().reload_current_scene()

func _on_trigger_mobs_portao_area_entered(area):
	SoundController.play_bgm(musica_fortress, "musica_fortress")
	$Trigger_Mobs_Portao.queue_free()

func _on_door_spawner_stopped_spawning():
	print("final stage")
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 3
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_final_stage_timer_timeout)
	SoundController.play_bgm(musica_intermission, "musica_intermission")

#func on_dead_enemy(_enemy, pontos):
#	GameManager.addPoints(pontos)

func _on_final_stage_timer_timeout():
	finalStage = true
