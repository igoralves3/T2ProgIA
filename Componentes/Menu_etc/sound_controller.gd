extends Node

@export var loopMusica: AudioStream
var volume_BGM: float = 50
var volume_SFX: float = 100
var volume_master: float = 100
@onready var AudioSFXArray= [AudioStreamPlayer]
@onready var Master:= AudioBusLayout
var SFXBusDic = ["SFX1","SFX2","SFX3","SFX4","SFX5","SFX6","SFX7","SFX8", "SFX9", "SFX10", "SFX11", "SFX12", "SFX13", "SFX14", "SFX15", "SFX16", "SFX17", "SFX18", "SFX19", "SFX20"]
@onready var AudioBGM = %AudioBGM
var musica_atual: String = ""

func _ready():
	AudioSFXArray = get_node("GroupSFX").get_children()

func play_button(Audio) -> void:
	var sfx = get_free_sfx_stream()
	if sfx != null:
		sfx.stream = Audio
		sfx.play()

func play_bgm(BGM, nome_string) -> void:
	musica_atual = nome_string
	AudioBGM.stream = BGM
	AudioBGM.play()

func get_free_sfx_stream():
	var streamSFX: AudioStreamPlayer
	for stream in AudioSFXArray:
		if !stream.playing:
			streamSFX = stream
			break
	return streamSFX

func set_sfx_volume(vol):
	for bus in SFXBusDic:
		var index = AudioServer.get_bus_index(bus)
		AudioServer.set_bus_volume_linear(index,vol)

func _on_audio_bgm_finished() -> void:
	print(musica_atual)
	if musica_atual == "musica_inicial" or musica_atual == "musica_retry" or musica_atual == "loop":
		print ("playyy")
		play_bgm(loopMusica, "loop")
