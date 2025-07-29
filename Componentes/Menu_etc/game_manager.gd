extends Node

var checkPoint: Vector2
var startPoint: Vector2
var hasCheckpoint: bool
var score: int = 0
var lifes: int = 3
var medals: int = 0 
var granadas: int = 5
var currentScene = ""
var retry = false #morreu e tá dando retry

func newGame():
	score = 0
	lifes = 3
	medals = 0
	hasCheckpoint = false
	retry = false
	granadas = 5

func reduceLifes():
	if lifes == 0:
		print("game over")
		currentScene = ""
		newGame()
		#get_tree().root.get_node("Game").change_scene("res://Componentes/Menu_etc/main_menu.tscn")
	else:
		lifes-=1
		print("vidas: ", lifes)

func setCheckPoint(newCheckPoint: Vector2):
	print(newCheckPoint)
	hasCheckpoint = true
	self.checkPoint = newCheckPoint

func setStartPoint(newStartPoint: Vector2):
	self.startPoint = newStartPoint

func addPoints(points: int):
	score += points
	if score%10000 == 0:
		lifes+=1
	print("score: ", score)

func addMedals():
	medals += 1

func getSpawnPostion():
	if hasCheckpoint:
		return checkPoint
	else: 
		return startPoint
