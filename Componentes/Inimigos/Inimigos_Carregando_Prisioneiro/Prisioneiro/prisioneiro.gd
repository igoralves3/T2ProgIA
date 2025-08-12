extends CharacterBody2D


@export var preso = true


@onready var _animated_sprite := $AnimatedSprite2D

signal queueFreeYourself


func _process(_delta: float) -> void:
	if preso:
		_animated_sprite.play("preso")
	else:
		_animated_sprite.play("livre")
		start_timer()


func start_timer():
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 3
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()


func _on_timer_timeout():
	GameManager.addPoints(1000)
	queueFreeYourself.emit()
