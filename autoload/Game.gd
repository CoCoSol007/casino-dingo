extends Node


var Money = 100
var FCC = 0

var gameOver = false

var BG_music: AudioStreamPlayer
var pieceSound: AudioStreamPlayer
var TimerGame:Timer

var save_path = "C:/Users/"+OS.get_environment("USERNAME")+"/AppData/Roaming/SaveCasinoDingo.json"

var has_talk_to_richard = false
var talk_to_bilyBoy = false
var first_co = true
var real_first_co = true

var state = 0

signal win
signal kill
signal changed_state(value)

signal update_money(new_value: int)
signal add_money(value:int)
signal substract_money(value:int)

signal update_FCC(new_value: int)
signal add_FCC(value:int)
signal substract_FCC(value:int)

#### Game ####

signal start_game()

func _ready():
	pieceSound = AudioStreamPlayer.new()
	pieceSound.set_stream(load("res://sound/1_Coins.ogg")) 
	add_child(pieceSound)
	pieceSound.set_volume_db(-10)
	
	BG_music = AudioStreamPlayer.new()
	BG_music.set_stream(load("res://sound/loop.ogg")) 
	add_child(BG_music)
	BG_music.set_volume_db(-30)
	BG_music.play()
	

	TimerGame = Timer.new()
	TimerGame.connect("timeout", _end_time)
	add_child(TimerGame)
	
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var save = JSON.parse_string(file.get_as_text())
		file.close()
		
		has_talk_to_richard = save["has_talk_to_richard"]
		first_co = save["first_co"]
		talk_to_bilyBoy = save["talk_to_bilyBoy"]
		var _fcc = int(save["FCC"])
		var _money = int(save["Money"])
		if int(save["Timer"]) != 0:
			TimerGame.start(int(save["Timer"]))
		gameOver = save["GameOver"]
		set_FCC(_fcc)
		set_money(_money)
	else:
		new_save()
	
	connect("tree_exiting", sync)
	connect("add_money", _add_money)
	connect("substract_money", _substract_money)
	connect("add_FCC", _add_FCC)
	connect("substract_FCC", _substract_FCC)
	connect("changed_state", state_mod)
	win.connect(_win)

func _win():
	Transit.change_scene_to_file("res://Scenes/win.tscn")

	
func _end_time():
	TimerGame.stop()
	gameOver = true
	sync()
	

func get_time_left():
	return TimerGame.get_time_left()


func new_save():
	gameOver = false
	set_FCC(0)
	set_money(100)
	has_talk_to_richard = false
	first_co = true
	real_first_co = true
	var data = {
		"first_co": true,
		"Money": 100,
		"FCC": 0,
		"has_talk_to_richard": false,
		"talk_to_bilyBoy": false,
		"Timer": 0,
		"GameOver": false
	}
	var json_string = JSON.stringify(data)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(json_string)
	
func sync():
	var time = 0
	if has_talk_to_richard:
		time = get_time_left()

	var data = {
		"first_co": first_co,
		"Money": get_money(),
		"FCC": get_FCC(),
		"has_talk_to_richard": has_talk_to_richard,
		"talk_to_bilyBoy": talk_to_bilyBoy,
		"Timer": time,
		"GameOver": gameOver 

	}

	var json_string = JSON.stringify(data)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(json_string)
	
func _add_money(value):
	pieceSound.play()	
	Money += value
	emit_signal("update_money", Money)
	sync()

func _substract_money(value):
	Money -= value
	emit_signal("update_money", Money)
	sync()

func get_money() : return Money

func set_money(value):
	Money = value
	emit_signal("update_money", Money)
	sync()
	
func change_talk_to_richard(value):
	if value != has_talk_to_richard:
		has_talk_to_richard = value
		TimerGame.start(60*60)	
		sync()
func change_first_co(value):
	first_co = value
	sync()
	
func _add_FCC(value):
	FCC += value
	pieceSound.play()		
	emit_signal("update_FCC", FCC)
	sync()

func _substract_FCC(value):
	FCC -= value
	emit_signal("update_FCC", FCC)
	sync()

func get_FCC() : return FCC

func set_FCC(value):
	FCC = value
	emit_signal("update_FCC", FCC)
	sync()

		
func state_mod(new_value):
	state = new_value

func change_talk_to_bilyBoy(value):
	talk_to_bilyBoy = value
	sync()
