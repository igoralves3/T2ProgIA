extends Node2D


@onready var player_label = $HUD/PlayerLabel
@onready var ready_label = $HUD/ReadyLabel
@onready var timer = $Timer

var show_player_label = true

func _ready():
	position = GameManager.getSpawnPostion()
	show_player_label=true
	
func _physics_process(delta: float) -> void:
	if show_player_label:
		player_label.visible = true
	else:
		player_label.visible = false
		
func _on_timer_timeout() -> void:
	show_player_label = !show_player_label
