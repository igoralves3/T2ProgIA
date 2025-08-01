extends Node2D

@onready var camera = %Camera2D
@onready var player = %MainPlayerChar
@onready var spawnInicial = $Marker2D
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

func _ready() -> void:
	GameManager.setStartPoint(spawnInicial.global_position)
	GameManager.currentScene = "res://Cenas/Area_2.tscn"
	%MainPlayerChar.global_position = GameManager.getSpawnPostion()

func _process(delta: float) -> void:
	finalMobsCount = get_tree().get_nodes_in_group("finalStageEnemies").size()
	if player.position.y - camera.offset.y < camera_distancia_y_minima and camera.offset.y >= camera_altura_maxima_y:
		camera.offset.y = player.position.y -camera_distancia_y_minima
	
	print (finalMobsCount)
	print (finalStage)
	if finalStage and finalMobsCount == 0:
		next_level()

func next_level():
	SoundController.play_bgm(musica_intermission, "musica_intermission")
	print("Voce venceu!")
	finalStage = false
	GameManager.addMedals()
	GameManager.hasCheckpoint = false
	get_tree().root.get_node("Game").change_scene("res://Cenas/Intermissions/intermission_2.tscn")


func _on_main_player_char_dead_player():
	GameManager.reduceLifes()
	get_tree().root.get_node("Game").change_scene("res://Cenas/Preload/preload.tscn")
	#get_tree().reload_current_scene()


func _on_trigger_body_entered(body):
	if body == %MainPlayerChar:
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 10
		add_child(timer)
		timer.start()
		timer.timeout.connect(_on_final_stage_timer_timeout)
		$Trigger.queue_free()
		SoundController.play_bgm(musica_fortress, "musica_fortress")

func _on_final_stage_timer_timeout():
	finalStage = true
