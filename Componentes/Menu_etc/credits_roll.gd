extends Control

@onready var Anim = get_node("AnimationCreditsRoll")
var mainmenu
func _ready() -> void:
	Anim.play("CreditsRoll")

func _process(delta: float) -> void:
	if not Anim.is_playing():
		queue_free()
		unhide_ui()

func menu_referencia(referencia):
	mainmenu = referencia
func unhide_ui():
	mainmenu.unhide_main_menu()

func _on_button_pressed() -> void:
	queue_free()
	unhide_ui()
