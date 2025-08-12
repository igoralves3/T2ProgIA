extends Control

var volumeMaster: float
var volumeBGM: float
var volumeSFX: float
@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var BGMBus = AudioServer.get_bus_index("BGM")
@export var credits_scene: PackedScene
@export var Area1_scene: PackedScene
@export var Somvfx: AudioStream
#@onready var MasterContr = SoundController

func _ready() -> void:
	SoundController.play_bgm(Somvfx, "Somvfx")

func _on_master_sound_slider_value_changed(value: float) -> void:
	var vol = value / 100
	
	AudioServer.set_bus_volume_linear(MasterBus,vol)
	volumeMaster = vol

func _on_bgm_slider_value_changed(value: float) -> void:
	var vol = value / 100
	AudioServer.set_bus_volume_linear(BGMBus, vol)
	volumeBGM = vol

func _on_sfx_slider_value_changed(value: float) -> void:
	var vol = value / 100
	SoundController.set_sfx_volume(vol)
	volumeSFX = vol
func _on_sfx_slider_drag_ended(_value_changed: bool) -> void:
	SoundController.play_button(Somvfx)

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	%OptionsContainer.hide()
	%ButtonsContainer.show()
#	MasterContr.play_button("res://UI/components/Sounds/Menu_click_1.ogg")

func _on_game_start_button_pressed() -> void:
	%DifficultyContainer.show()
	%ButtonsContainer.hide()
#	MasterContr.play_button("res://UI/components/Sounds/Menu_click_1.ogg")

func _on_options_button_pressed() -> void:
	%OptionsContainer.show()
	%ButtonsContainer.hide()
#	MasterContr.play_button("res://UI/components/Sounds/Menu_click_1.ogg")

func _on_credits_button_pressed() -> void:
	var credits = credits_scene.instantiate()
	add_child(credits)
	credits.menu_referencia(self)
#	MasterContr.play_button("res://UI/components/Sounds/Menu_click_1.ogg")
	%UIContainer.hide()


func _on_back_button_difficulty_pressed() -> void:
	%DifficultyContainer.hide()
	%ButtonsContainer.show()
#	MasterContr.play_button("res://UI/components/Sounds/Menu_click_1.ogg")



func _on_easy_button_pressed() -> void:
	
#	GameManager.DificuldadeAtual = GameManager.DifficuldadeIA.FACIL
#	var tabuleiro = tabuleiro_scene.instantiate()
#	add_child(tabuleiro)
	%UIContainer.hide()
#	MasterContr.play_button("res://UI/components/Sounds/Laugh_spooky_4.ogg")

func _on_impossivel_button_pressed() -> void:
	GameManager.newGame()
	GameManager.currentScene = "res://Cenas/Area_1.tscn"
	get_tree().root.get_node("Game").change_scene("res://Cenas/Preload/preload.tscn")
	#get_tree().root.get_node("Game").change_scene("res://Cenas/Area_1.tscn")

func unhide_main_menu():
	%UIContainer.show()


func _on__players_pressed():
	#GameManager.DificuldadeAtual = GameManager.DifficuldadeIA.PVP
	#var tabuleiro = tabuleiro_scene.instantiate()
	#add_child(tabuleiro)
	%UIContainer.hide()
	#MasterContr.play_button("res://UI/components/Sounds/Laugh_spooky_4.ogg")


func _on_master_sound_slider_drag_ended(_value_changed: bool) -> void:
	SoundController.play_button(Somvfx)


func _on_bgm_slider_drag_ended(_value_changed: bool) -> void:
	SoundController.play_bgm(Somvfx, "Somvfx")
