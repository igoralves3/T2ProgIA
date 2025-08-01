extends Node2D


@onready var player_label = $HUD/PlayerLabel
@onready var ready_label = $HUD/ReadyLabel
@onready var timer = $Timer
@onready var texture = $Control/CanvasLayer/TextureRect
@export var textura_area2: Texture
@export var textura_area3: Texture

var piscadas_restantes = 10
var next_scene
var show_player_label = true

func _ready():
	next_scene = GameManager.currentScene
	var position1 = GameManager.getSpawnPostion()
	print (position1)
	texture.global_position.y = texture.global_position.y - position1.y +170
	show_player_label=true
	if next_scene == "res://Cenas/Area_2.tscn":
		texture.texture = textura_area2
	if next_scene == "res://Cenas/Area_3.tscn":
		texture.texture = textura_area3
	
func _physics_process(delta: float) -> void:
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
