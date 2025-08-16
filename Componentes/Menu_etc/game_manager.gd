extends Node

var checkPoint: Vector2
var startPoint:= Vector2(112,170)
var hasCheckpoint: bool
var score: int = 0
var extra_life_score: int = 10000
var lives: int = 3
var medals: int = 0 
var granadas: int = 5
var currentScene = ""
var retry = false #morreu e tá dando retry
var highscores = [
	{"nick": "VULGUS", "highscore": 50000},
	{"nick": "SON.SON", "highscore": 30000},
	{"nick": "HIGEMARU", "highscore": 20000},
	{"nick": "CAPCOM", "highscore": 19420},
	{"nick": "EXED.EXES", "highscore": 12000},
	{"nick": "COMMANDO", "highscore": 10000},
	{"nick": "", "highscore": 8000}]
var highscore
var extra_lives: bool = false

signal score_updated(new_score)
#signal grenades_updated(new_grenade_count)
signal lives_updated(new_life_count)
signal medals_updated(new_medal_count)

func _ready() -> void:
	SaveManager.load_game()
	load_highscores()
	arrumar_highscores()
	highscore = highscores[0].highscore
	process_mode = Node.PROCESS_MODE_ALWAYS

func check_for_new_high_score():
	if score > highscore:
		print("Novo recorde! Score: ", score)
		highscore = score
		SaveManager.high_score = highscore
		SaveManager.save_game() # Salva o novo recorde no arquivo!

func newGame():
	score = 0
	lives = 3
	if extra_lives:
		lives = 9
	medals = 0
	hasCheckpoint = false
	retry = false
	granadas = 5
	extra_life_score = 10000

func reducelives():
	if lives == 0:
		pass
#		print("game over game manager")
#		currentScene = "res://Componentes/Menu_etc/main_menu.tscn"
#		newGame()
#		SoundController.AudioBGM.stop()
#		get_tree().root.get_node("Game").change_scene("res://Componentes/Menu_etc/main_menu.tscn")
	else:
		lives-=1
		lives_updated.emit(lives)

func setCheckPoint(newCheckPoint: Vector2):
	print(newCheckPoint)
	hasCheckpoint = true
	self.checkPoint = newCheckPoint

func setStartPoint(newStartPoint: Vector2):
	self.startPoint = newStartPoint

func addPoints(points: int):
	score += points
	score_updated.emit(score)
	check_for_new_high_score()
	if score >= extra_life_score:
		lives+=1
		if extra_lives:
			lives+=2
		lives_updated.emit(lives)
		extra_life_score = extra_life_score + 10000

func addMedals():
	medals += 1
	medals_updated.emit(medals)

func getSpawnPostion():
	if hasCheckpoint:
		return checkPoint
	else: 
		return startPoint

func arrumar_highscores():
	highscores.sort_custom(func(a, b): return a.highscore > b.highscore)

func save_highscores():
#	var arquivo = FileAccess.open("user://highscores.sav", FileAccess.WRITE)
	var arquivo = FileAccess.open("./highscores.sav", FileAccess.WRITE)
	arquivo.store_var(highscores)

func load_highscores():
#	if FileAccess.file_exists("user://highscores.sav"):
#		var arquivo = FileAccess.open("user://highscores.sav", FileAccess.READ)
	if FileAccess.file_exists("./highscores.sav"):
		var arquivo = FileAccess.open("./highscores.sav", FileAccess.READ)
		highscores = arquivo.get_var()

func adicionar_novo_highscore(nome, h_score):
	highscores.append({"nick": nome, "highscore": h_score})
	arrumar_highscores()
	if highscores.size() > 7:
		highscores = highscores.slice(0, 7)
	save_highscores()
