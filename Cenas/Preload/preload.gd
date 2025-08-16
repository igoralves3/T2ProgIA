extends Node2D

@export var musica_inicial: AudioStream
@export var musica_intermission: AudioStream
@export var musica_retry: AudioStream
@export var musica_fortress: AudioStream
@onready var player_label = $HUD/PlayerLabel
@onready var ready_label = $HUD/ReadyLabel
@onready var timer = $Timer
@onready var texture = $Control/CanvasLayer/TextureRect
@export var textura_area2: Texture
@export var textura_area3: Texture
@export var textura_area1: Texture

var piscadas_restantes = 10
var next_scene
var show_player_label = true

func _ready():
	if GameManager.lives == 0: #a principio nao eh chamado
		SoundController.AudioBGM.stop()
#		get_tree().root.get_node("Game").change_scene("res://Componentes/Menu_etc/main_menu.tscn")
		return
	if GameManager.retry:
		SoundController.play_bgm(musica_retry, "musica_retry")
	if not GameManager.retry:
		SoundController.play_bgm(musica_inicial, "musica_inicial")
	next_scene = GameManager.currentScene
	var position1 = GameManager.getSpawnPostion()
	texture.global_position.y = texture.global_position.y - position1.y +170
	show_player_label=true
	if next_scene == "res://Cenas/Area_1.tscn":
		texture.texture = textura_area1
	if next_scene == "res://Cenas/Area_2.tscn":
		texture.texture = textura_area2
	if next_scene == "res://Cenas/Area_3.tscn":
		texture.texture = textura_area3


func _physics_process(_delta: float) -> void:
	if show_player_label:
		player_label.visible = true
	else:
		player_label.visible = false

func _on_timer_timeout() -> void:
	show_player_label = !show_player_label
	
	if piscadas_restantes > 0:
		piscadas_restantes =piscadas_restantes - 1
	if piscadas_restantes <= 0:
		trocar_fase_retry()
		
func trocar_fase_retry():
	get_tree().root.get_node("Game").change_scene(next_scene)
