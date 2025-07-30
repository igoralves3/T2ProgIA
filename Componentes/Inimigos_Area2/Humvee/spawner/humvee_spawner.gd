extends Area2D

@export var humvee : PackedScene
var canSpawn = false

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	if canSpawn:
		var humvee_instance = humvee.instantiate()
		humvee_instance.position = position
		get_parent().add_child(humvee_instance)
		canSpawn = false
		queue_free()
		#area.add_child(moto)


func _on_area_entered(area: Area2D) -> void:
	canSpawn = true
