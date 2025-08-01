extends State
class_name Straight

@export var character: CharacterBody2D
@export var move_speed: float = 50.0
var move_direction: float = -1
var timer_para_mudar_de_estado: Timer
var pode_mudar_de_estado: bool = false
var wander_time:float
#signal transitioned

func _ready() -> void:
	print('straight')
	wander_time=.5
	timer_para_mudar_de_estado = Timer.new()
	timer_para_mudar_de_estado.wait_time = 1
	timer_para_mudar_de_estado.one_shot = false
	timer_para_mudar_de_estado.timeout.connect(timer_para_mudar_de_estado_end)
	pode_mudar_de_estado=false
	add_child(timer_para_mudar_de_estado)
	
	
func _enter()->void:
	pass

func exit() -> void:
	pass
	
func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		pode_mudar_de_estado=true
	
func physics_update(delta: float) -> void:
	character.position.x += move_direction*move_speed * delta
	character.position.y += move_speed * delta * 0.5
	if pode_mudar_de_estado:
		transitioned.emit(self,"Wander")

func collision_update():
	pass

func timer_para_mudar_de_estado_end():
	pode_mudar_de_estado=true
