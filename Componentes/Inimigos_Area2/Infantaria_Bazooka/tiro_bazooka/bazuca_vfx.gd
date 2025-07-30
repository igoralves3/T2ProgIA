extends AnimatedSprite2D

var flip_horizontal: bool = false
var offset_animation
var tempo_para_sumir: float = 0.05
var pontos: int = 400

func _ready():
	flip_h = flip_horizontal
#	offset = offset_animation
	#self.play("default")
	pass

func _physics_process(delta: float) -> void:
	tempo_para_sumir = tempo_para_sumir - delta
	if tempo_para_sumir < 0:
		queue_free()
