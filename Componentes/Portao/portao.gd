extends Node2D

@onready var _animated_sprite2D := $AnimatedSprite2D
var ativo = false
var door_open = false

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	if ativo:
		if not door_open:
			_animated_sprite2D.play("open")
		if _animated_sprite2D.frame == 2:
			_animated_sprite2D.stop()
			_animated_sprite2D.frame = 2
			door_open=true

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	ativo = true

func _on_trigger_mobs_portao_area_entered(area):
	print("abre os portoes")
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(func():
		print("abertos")
		door_open = true
	)
