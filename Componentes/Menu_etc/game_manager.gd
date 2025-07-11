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

func setCheckPoint(newCheckPoint: Vector2):
	self.checkPoint = newCheckPoint

func setStartPoint(newStartPoint: Vector2):
	self.startPoint = newStartPoint

func addPoints(points: int):
	score += points

func getSpawnPostion():
	if hasCheckpoint:
		return checkPoint
	else: 
		return startPoint
