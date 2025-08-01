extends Node

var current_scene = null

func _ready():
	if (GameManager.currentScene != ""):
		change_scene(GameManager.currentScene)
	else:
		change_scene("res://Componentes/Menu_etc/main_menu.tscn")

func change_scene(scene_path):
	# Se já houver uma cena, remova-a
	if current_scene != null:
		current_scene.queue_free()

	# Carregue a nova cena
	var scene = load(scene_path)
	current_scene = scene.instantiate()

	# Adicione a nova cena como filha do nó raiz
	add_child(current_scene)
