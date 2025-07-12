extends AnimatedSprite2D

var flip_horizontal: bool = false
var offset_animation
var tempo_para_sumir: float = 0.12

func _ready():
	flip_h = flip_horizontal
	offset = offset_animation
	self.play("default")
	await self.animation_finished
	queue_free()
	pass
