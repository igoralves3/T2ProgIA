extends Resource

class_name Infantaria

var vida: int
var type: String
var speed: int
var fireRate: float


func _init(vida: int, type: String, speed: int, fireRate: float) -> void:
	self.vida = vida
	self.type = type
	self.speed = speed
	self.fireRate = fireRate
	
func movimentacao():
	pass
