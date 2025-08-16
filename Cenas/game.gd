extends Node

var current_scene = null
var timer_game_over
@export var gameOver_audio: AudioStream

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	if (GameManager.currentScene != ""):
		change_scene(GameManager.currentScene)
	else:
#		change_scene("res://Componentes/Menu_etc/main_menu.tscn")
		change_scene("res://Componentes/Menu_etc/menu.tscn")
	timer_game_over = Timer.new()
	timer_game_over.wait_time = 6
	timer_game_over.autostart = false
	timer_game_over.one_shot = true
	add_child(timer_game_over)
	timer_game_over.timeout.connect(highscore_scene)

func change_scene(scene_path):
	if current_scene != null:
		current_scene.queue_free()
	var scene = load(scene_path)
	current_scene = scene.instantiate()
	add_child(current_scene)

func add_scene(scene_path):
	var scene = load(scene_path)
	var scene_inst = scene.instantiate()
	scene_inst.global_position = get_tree().get_first_node_in_group("GrupoPlayer").posicao_camera + Vector2(112,128)
	if current_scene != null:
		current_scene.add_child(scene_inst)

func game_over():
	add_scene("res://Componentes/Menu_etc/game_over_labels.tscn")
	get_tree().paused = true
	timer_game_over.start()
	SoundController.play_bgm(gameOver_audio, "GameOver")

func highscore_scene():
	var next_scene = GameManager.currentScene
	var posicao_texture = get_tree().get_first_node_in_group("GrupoPlayer").posicao_camera.y
	get_tree().paused = false
	change_scene("res://Componentes/Menu_etc/adicionar_highscore.tscn")
	current_scene.texture.global_position.y = current_scene.texture.global_position.y - posicao_texture
	if next_scene == "res://Cenas/Area_1.tscn":
		current_scene.texture.texture = current_scene.textura_area1
	if next_scene == "res://Cenas/Area_2.tscn":
		current_scene.texture.texture = current_scene.textura_area2
	if next_scene == "res://Cenas/Area_3.tscn":
		current_scene.texture.texture = current_scene.textura_area3
	
