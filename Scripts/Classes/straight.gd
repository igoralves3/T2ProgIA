extends State
class_name Straight

@export var character: CharacterBody2D
@export var move_speed: float = 50.0
@export var move_direction: Vector2
var wait_time_mudar_de_estado: float
var timer_para_mudar_de_estado: Timer
var pode_mudar_de_estado: bool = false
var wander_time:float
#signal transitioned

func _ready() -> void:
	print('straight')
	wait_time_mudar_de_estado=1
	wander_time=1
	timer_para_mudar_de_estado = Timer.new()
	timer_para_mudar_de_estado.wait_time=wait_time_mudar_de_estado
	timer_para_mudar_de_estado.one_shot = false
	timer_para_mudar_de_estado.timeout.connect(timer_para_mudar_de_estado_end)
	pode_mudar_de_estado=false
	add_child(timer_para_mudar_de_estado)
	
	
func _enter()->void:
	print('straight')
	wait_time_mudar_de_estado=1
	wander_time=1
	timer_para_mudar_de_estado = Timer.new()
	timer_para_mudar_de_estado.wait_time=wait_time_mudar_de_estado
	timer_para_mudar_de_estado.one_shot = false
	timer_para_mudar_de_estado.timeout.connect(timer_para_mudar_de_estado_end)
	pode_mudar_de_estado=false
	add_child(timer_para_mudar_de_estado)

func exit() -> void:
	pass
	
func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		pode_mudar_de_estado=true
	
func physics_update(delta: float) -> void:
	character.position.x += move_direction.x*move_speed * delta
	if pode_mudar_de_estado:
		print('mudou')
		transitioned.emit(self,"Hover")
		
func collision_update():
	pass
		
	
func timer_para_mudar_de_estado_end():
	pode_mudar_de_estado=true
	
	
