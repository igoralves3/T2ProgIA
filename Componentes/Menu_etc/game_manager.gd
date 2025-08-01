extends Node

var checkPoint: Vector2
var startPoint: Vector2
var hasCheckpoint: bool
var score: int = 0
var extra_life_score: int = 10000
var lifes: int = 3
var medals: int = 0 
var granadas: int = 5
var currentScene = ""
var retry = false #morreu e tá dando retry

signal score_updated(new_score)
signal grenades_updated(new_grenade_count)
signal lives_updated(new_life_count)
signal medals_updated(new_medal_count)

func newGame():
	score = 0
	lifes = 299
	medals = 0
	hasCheckpoint = false
	retry = false
	granadas = 5
	extra_life_score = 10000

func reduceLifes():
	if lifes == 0:
		print("game over")
		currentScene = ""
		newGame()
		get_tree().root.get_node("Game").change_scene("res://Componentes/Menu_etc/main_menu.tscn")
	else:
		lifes-=1
		lives_updated.emit(lifes)
		print("vidas: ", lifes)

func setCheckPoint(newCheckPoint: Vector2):
	print(newCheckPoint)
	hasCheckpoint = true
	self.checkPoint = newCheckPoint

func setStartPoint(newStartPoint: Vector2):
	self.startPoint = newStartPoint

func addPoints(points: int):
	score += points
	score_updated.emit(score)
	if score >= extra_life_score:
		lifes+=1
		lives_updated.emit(lifes)
		extra_life_score = extra_life_score + 10000
	print("score: ", score)

func addMedals():
	medals += 1
	medals_updated.emit(medals)

func getSpawnPostion():
	if hasCheckpoint:
		return checkPoint
	else: 
		return startPoint
