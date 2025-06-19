extends CharacterBody2D

class_name Infantaria

var vida: int
var type: String
var speed: int
var pontos: int
var fireRate: float
var alvo: CharacterBody2D


func _init(vida: int, type: String, speed: int, fireRate: float, pontos: int, alvo: CharacterBody2D) -> void:
	self.vida = vida
	self.type = type
	self.speed = speed
	self.fireRate = fireRate
	self.pontos =  pontos
	self.alvo = alvo
	
func _physics_process(delta: float) -> void:
	move_and_slide()
