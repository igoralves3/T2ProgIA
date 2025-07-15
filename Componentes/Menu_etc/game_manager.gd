extends Node

var checkPoint: Vector2
var startPoint: Vector2
var hasCheckpoint: bool
var score: int
var lifes: int
var medals: int

func newGame():
	score = 0
	lifes = 3
	medals = 0
	hasCheckpoint = false
	print("vidas: ", lifes)
	

func restartGame():
	if lifes == 0:
		print("game over")
		newGame()
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
	print("score: ", score)

func getSpawnPostion():
	if hasCheckpoint:
		return checkPoint
	else: 
		return startPoint
