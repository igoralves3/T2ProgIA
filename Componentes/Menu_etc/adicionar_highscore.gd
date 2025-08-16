extends Control

var nickname: String
@export var label_nick: Label
@export var hud: CanvasLayer
@export var RanksGroup: Array[Label]
@onready var timer_end = $Timer
@onready var timer_next_scene = $timer_next_scene
@onready var texture = $TextureRect
@export var textura_area1: Texture
@export var textura_area2: Texture
@export var textura_area3: Texture

func _ready() -> void:
	$GridContainer/A.grab_focus()
	hud.vidas_box.visible = false
	hud.granadas_box.visible = false
	timer_end.timeout.connect(finalizar_pt2)
	timer_next_scene.timeout.connect(next_scene)

func add_letra(letra):
	nickname = nickname + letra
	var nickname_temp = nickname
	while nickname_temp.length() < 10:
		nickname_temp = nickname_temp + "."
	nickname_temp = nickname_temp + "-"
	label_nick.text = nickname_temp
	if nickname.length() == 10:
		finalizar()

func finalizar():
	GameManager.adicionar_novo_highscore(nickname, GameManager.score)
	timer_end.start()
	var highscore_gm = GameManager.highscores
	var nick_inst: String
	for i in range(highscore_gm.size()):
		nick_inst = highscore_gm[i].nick
		while nick_inst.length() < 10:
			nick_inst = nick_inst + "."
		RanksGroup[i].text = str(highscore_gm[i].highscore) + " " + nick_inst
	var array_botoes = $GridContainer.get_children()
	for botao in array_botoes:
		botao.disabled = true

func finalizar_pt2():
	$GridContainer.visible = false
	$Nick.visible = false
	$Highscores_Control.visible = true
	timer_next_scene.start()

func next_scene():
	get_tree().root.get_node("Game").change_scene("res://Componentes/Menu_etc/menu.tscn")

func _on_a_pressed() -> void:
	add_letra("A")
func _on_b_pressed() -> void:
	add_letra("B")
func _on_c_pressed() -> void:
	add_letra("C")
func _on_d_pressed() -> void:
	add_letra("D")
func _on_e_pressed() -> void:
	add_letra("E")
func _on_f_pressed() -> void:
	add_letra("F")
func _on_g_pressed() -> void:
	add_letra("G")
func _on_h_pressed() -> void:
	add_letra("H")
func _on_i_pressed() -> void:
	add_letra("I")
func _on_j_pressed() -> void:
	add_letra("J")
func _on_k_pressed() -> void:
	add_letra("K")
func _on_l_pressed() -> void:
	add_letra("L")
func _on_m_pressed() -> void:
	add_letra("M")
func _on_n_pressed() -> void:
	add_letra("N")
func _on_o_pressed() -> void:
	add_letra("O")
func _on_p_pressed() -> void:
	add_letra("P")
func _on_q_pressed() -> void:
	add_letra("Q")
func _on_r_pressed() -> void:
	add_letra("R")
func _on_s_pressed() -> void:
	add_letra("S")
func _on_t_pressed() -> void:
	add_letra("T")
func _on_u_pressed() -> void:
	add_letra("U")
func _on_v_pressed() -> void:
	add_letra("V")
func _on_w_pressed() -> void:
	add_letra("W")
func _on_x_pressed() -> void:
	add_letra("X")
func _on_y_pressed() -> void:
	add_letra("Y")
func _on_z_pressed() -> void:
	add_letra("Z")
func _on_ponto_pressed() -> void:
	add_letra(".")
func _on_espaco_pressed() -> void:
	add_letra(" ")
func _on_igual_pressed() -> void:
	add_letra("=")
func _on_end_pressed() -> void:
	finalizar()
