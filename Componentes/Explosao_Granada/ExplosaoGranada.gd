extends Area2D

var tempo_para_sumir: float = 0.258 #+- isso
var dono: String = ""

@onready var SFXGranadeBlast = $SFXGranadeBlast


func _ready():
	%Timer.wait_time = tempo_para_sumir
	%Timer.start()
#	print('explosao')
	SFXGranadeBlast.play()
	$AnimatedSprite2D.play()
	if dono == "Player": #jogador
		set_collision_layer_value(2, true) #layer do jogador
		set_collision_mask_value(3, true) #ver inimigos
		set_collision_mask_value(4, true) #ver objetos destrutiveis
	else: #inimigo
		set_collision_layer_value(3, true) #layer do inimigo
		set_collision_mask_value(2, true) #ver jogador

#func _process(delta: float) -> void:
#	print (dono)

func _on_timer_timeout() -> void:
#	print('fim explosao')
	queue_free()


func _on_body_entered(body: Node2D) -> void:
#	print (body)
	if body.has_method("grenade_hit"):
		body.grenade_hit()
		
	if dono != "Player" and body.has_method("death_normal"):
		body.death_normal()
