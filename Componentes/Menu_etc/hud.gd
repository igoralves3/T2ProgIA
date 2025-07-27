extends CanvasLayer

@export var vida_extra: TextureRect
@export var medalha1: TextureRect
@export var label_granadas: Label
@export var label_score_normal: Label
@export var label_high_score: Label
var updates: int = 5

func _ready() -> void:
	for child in $%VidasExtrasHBox.get_children():
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

func update_geral():
	if label_high_score.text.is_valid_int():
		if GameManager.score > int(label_high_score.text):
			label_high_score.text = str(GameManager.score)
	label_score_normal.text = str(GameManager.score)
	label_granadas.text = str(GameManager.granadas)
	if $%VidasExtrasHBox.get_child_count() < GameManager.lifes:
		var nova_vida = vida_extra.duplicate()
		$%VidasExtrasHBox.add_child(nova_vida)
	if $%VidasExtrasHBox.get_child_count() > GameManager.lifes:
		$%VidasExtrasHBox.get_children().front().queue_free()
	if $%Medalhas.get_child_count() < GameManager.medals:
		var nova_medalha = medalha1.duplicate()
		$%Medalhas.add_child(nova_medalha)
	if $%Medalhas.get_child_count() > GameManager.medals:
		$%Medalhas.get_children().front().queue_free()
	updates = updates - 1
	if updates > 0:
		update_geral()
