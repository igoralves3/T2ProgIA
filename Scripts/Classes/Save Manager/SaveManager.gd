extends Node

const SAVE_PATH = "user://save_game.cfg"

var high_score = GameManager.highscore

func save_game():
	var config = ConfigFile.new()
	config.set_value("player_stats", "high_score", high_score)
	
	var error = config.save(SAVE_PATH)
	if error != OK:
		print("Erro ao salvar o arquivo!")
	print("JOGO SALVO! Novo high score é: ", high_score)

func load_game():
	var config = ConfigFile.new()
	
	# Verifica se o arquivo de save existe antes de tentar carregar
	if not FileAccess.file_exists(SAVE_PATH):
		print("Nenhum arquivo de save encontrado. Usando score padrão.", high_score)
		return # Sai da função se não houver arquivo

	# Carrega o arquivo do disco
	var error = config.load(SAVE_PATH)
	if error != OK:
		print("Erro ao carregar o arquivo!")
		return
		
	# Pega o valor do arquivo. Se a chave não existir, usa 0 como padrão.
	high_score = config.get_value("player_stats", "high_score", GameManager.highscore)
	print("JOGO CARREGADO! High score atual é: ", high_score)
