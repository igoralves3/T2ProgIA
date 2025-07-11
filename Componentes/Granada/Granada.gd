extends Area2D

class_name  Grenade

@export var motion := Vector2(0,0)
var tempo_para_sumir: float = 0.72 
const SPEED = 125.0 #para andar 90 pixels

var dono: String = ""
@export var explosao: PackedScene

#var frames : float = 0.0

#const maxFrames = 60

func _ready():
	%Timer.wait_time = tempo_para_sumir
	%Timer.start()
	#print('grenade')

#func _physics_process(delta: float) -> void:
	
	#position += motion * SPEED * delta
	
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	queue_free()

func gera_explosao():
	var explosao_instance = explosao.instantiate()
	explosao_instance.global_transform = global_transform
#	if dono:
	explosao_instance.dono = dono
	get_parent().add_child(explosao_instance)

func _on_timer_timeout() -> void:
	gera_explosao()
	queue_free()
