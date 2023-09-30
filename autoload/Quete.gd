extends Node

enum GameMachine {
	SloteMachine,
	BlackJack
}

signal new_victoir(game: GameMachine)
signal new_defait(game: GameMachine)
signal new_quete(num)
signal annuler()
signal finished()

var get_price = 0

var current_quete = 0
var num_task = 0 
var goal_num_task = 1 
var price = null

var loosesound: AudioStreamPlayer
# Black jack 1
# Slote Machine 2

func _ready():
	loosesound = AudioStreamPlayer.new()
	loosesound.set_stream(load("res://sound/fail.ogg")) 
	add_child(loosesound)
	loosesound.set_volume_db(-5)
	
	new_victoir.connect(_victoir_manager)
	new_defait.connect(defait_manager)
	new_quete.connect(set_new_quete)
	annuler.connect(_annuller_quete)

func _annuller_quete():
	restart()

func _victoir_manager(game):
	if current_quete != 0:
		if game == GameMachine.BlackJack:
			if _is_valide_task(1):
				num_task += 1
		else :
			if _is_valide_task(2):
				num_task += 1

func defait_manager(gameM):
	loosesound.play()
	if current_quete != 0:
		if gameM == GameMachine.BlackJack:
			if _is_valide_task(1):
				num_task = 0
		else :
			if _is_valide_task(2):
				num_task = 0

func set_new_quete(num):
	current_quete = num
	goal_num_task = get_goal_num_task(num) 
	price = get_price_task(num) 

func restart():
	current_quete = 0
	num_task = 0 
	goal_num_task = 1 
	price = 0

func _process(_delta):
	if num_task == goal_num_task:
		get_price += price
		finished.emit()
		restart()
		
func get_all_price():
	return get_price
		
func get_goal_num_task(num):
	if num == 1:
		return 2
	elif num == 2:
		return 5
	elif num == 3:
		return 7
	elif num == 4:
		return 2
	elif num == 5:
		return 5
	elif num == 6:
		return 7

func get_price_task(num):
	if num == 1:
		return 200
	elif num == 2:
		return 1000
	elif num == 3:
		return 5000
	elif num == 4:
		return 2000
	elif num == 5:
		return 10000
	elif num == 6:
		return 50000
	
func _is_valide_task(num):
	var cas = 2
	if current_quete == 1 or current_quete == 2 or current_quete == 3 :
		cas = 1
		
	if num == cas:
		return true
	else: return false
	

