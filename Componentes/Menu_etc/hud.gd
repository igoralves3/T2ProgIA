extends CanvasLayer

@export var vida_extra: TextureRect
@export var medalha1: TextureRect
@export var label_granadas: Label
@export var label_score_normal: Label
@export var label_high_score: Label
var updates: int = 5
@export var vidas_box: HBoxContainer
@export var granadas_box: HBoxContainer

func _ready() -> void:
	GameManager.score_updated.connect(on_score_update)
	GameManager.lives_updated.connect(on_lives_update)
	GameManager.medals_updated.connect(on_medals_update)
	for child in vidas_box.get_children():
		child.queue_free()
	for medalhas in %Medalhas.get_children():
		medalhas.queue_free()
	
	start_update()
	var timer1 = get_tree().create_timer(0.1)
	timer1.timeout.connect(start_update)

func start_update():
	updates = 5
	update_geral()

func single_update():
	updates = 1
	update_geral()
	

func on_score_update(_new_score):
	update_geral()
	
func on_lives_update(_new_lives):
	if GameManager.extra_lives:
		update_geral()
		update_geral()
	update_geral()

func on_medals_update(_new_medals):
	update_geral()


func update_geral():
	if label_high_score.text.is_valid_int():
		if GameManager.score > int(label_high_score.text):
			label_high_score.text = str(GameManager.score)
	label_score_normal.text = str(GameManager.score)
	label_granadas.text = str(GameManager.granadas)
	if vidas_box.get_child_count() < GameManager.lives and vidas_box.get_child_count() < 5:
		var nova_vida = vida_extra.duplicate()
		vidas_box.add_child(nova_vida)
	if vidas_box.get_child_count() > GameManager.lives and vidas_box.get_child_count() >= 5 :
		vidas_box.get_children().front().queue_free()
	if $%Medalhas.get_child_count() < GameManager.medals:
		var nova_medalha = medalha1.duplicate()
		$%Medalhas.add_child(nova_medalha)
	if $%Medalhas.get_child_count() > GameManager.medals:
		$%Medalhas.get_children().front().queue_free()
	updates = updates - 1
	if updates > 0:
		update_geral()
