extends Control

@export var label_coin: Label
@export var control_first_area: Control
@export var control_second_area: Control
@export var control_third_area: Control
@export var timer_coin_time: float = 1
@export var timer_area_change: float = 4
@export var RanksGroup: Array[Label]
@export var superjoesprite: AnimatedSprite2D
@export var label_highestscore_top: Label


func _ready() -> void:
	var new_timer_coin = Timer.new()
	new_timer_coin.wait_time = timer_coin_time
	new_timer_coin.one_shot = false
	new_timer_coin.timeout.connect(timer_coin)
	add_child(new_timer_coin)
	new_timer_coin.start()
	var new_timer_area_change = Timer.new()
	new_timer_area_change.wait_time = timer_area_change
	new_timer_area_change.one_shot = false
	new_timer_area_change.timeout.connect(timer_area)
	add_child(new_timer_area_change)
	new_timer_area_change.start()
	superjoesprite.play()
	superjoesprite.speed_scale = 0.5
	label_highestscore_top.text = str(GameManager.highscores[0].highscore)
	ordernar_highscore()
	$StartButton.grab_focus()

func timer_coin():
	if label_coin.visible:
		label_coin.visible = false
	else:
		label_coin.visible = true

func timer_area():
	if control_first_area.visible:
		control_first_area.visible = false
		control_second_area.visible = true
	elif control_second_area.visible:
		control_second_area.visible = false
		control_third_area.visible = true
	else:
		control_third_area.visible = false
		control_first_area.visible = true

func ordernar_highscore():
	var highscore_gm = GameManager.highscores
	var nick_inst: String
	for i in range(highscore_gm.size()):
		nick_inst = highscore_gm[i].nick
		while nick_inst.length() < 10:
			nick_inst = nick_inst + "."
		RanksGroup[i].text = str(highscore_gm[i].highscore) + " " + nick_inst


func _on_button_pressed() -> void:
	GameManager.newGame()
	GameManager.currentScene = "res://Cenas/Area_1.tscn"
	get_tree().root.get_node("Game").change_scene("res://Cenas/Preload/preload.tscn")


func _on_check_button_toggled(toggled_on: bool) -> void:
	GameManager.extra_lives = toggled_on
