extends Node2D
signal update_bet(value :int)

var colone1 = 270
var colone2 = 550
var colone3 = 829


var killing = false
var kill_just = false

@onready var Button_Sound = $Button_Sound
@onready var tic_sound = $tic_sound
var can_run = true
var bet = 100

func get_bet() : return bet

func _process(_delta):
	if GAME.gameOver:
		if !kill_just:
			kill_just = true
			if GAME.get_money() == 0 and GAME.get_FCC() == 0:
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/slotMachine.dialogue"), "start")	
			else:
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/slotMachine.dialogue"), "PlusDeTemps")	
	if killing:
		var new = GAME.get_FCC()-1
		GAME.emit_signal("substract_FCC", max(0, new))

func _on_touch_screen_button_button_down():
	Button_Sound.play()
	$HUD/HUD/Button.disabled = true
	if !GAME.gameOver:
		if can_run :
			if GAME.get_FCC() - bet  >= 0:	
				GAME.emit_signal("changed_state", 1)			
				GAME.emit_signal("start_game")
				GAME.emit_signal("substract_FCC", bet)
				can_run = false

func _on_add_bet_button_button_down():
	Button_Sound.play()
	if !GAME.gameOver:
		if can_run :
			bet += 100
			emit_signal("update_bet", bet)
	
func _on_substract_bet_button_button_down():
	Button_Sound.play()
	if !GAME.gameOver:
		if can_run :
			if bet-100 > 0: 
				bet -= 100
				emit_signal("update_bet", bet)
		
	
func _ready():
	$AnimationPlayer.stop()
	$Colun3.connect("finished", _get_result)
	$Colun3.connect("pass_", do_tic_sound)
	$Colun2.connect("pass_", do_tic_sound)
	$Colun.connect("pass_", do_tic_sound)
	GAME.kill.connect(_kill)

func do_tic_sound():
	tic_sound.play()

func _get_result():
	$HUD/HUD/Button.disabled = false
	
	var res1 = $Colun.win_image
	var res2 = $Colun2.win_image
	var res3 = $Colun3.win_image
	
	
	var win_number = get_number_win(res1, res2, res3)  
	
	if win_number[0] != -1:
		_pay_player(win_number[0], win_number[1])
	else :
		QUETE.emit_signal("new_defait", QUETE.GameMachine.SloteMachine)
		if GAME.get_money() == 0 and GAME.get_FCC() == 0:
			GAME.gameOver = true
			GAME.sync()
	GAME.emit_signal("changed_state", 0)
	can_run = true

func get_number_win(a,b,c):
	if a == b and b == c:
		return [a, 3]
	elif a == b:
		return [a, 2]
	elif b == c:
		return [b, 2]
	else:
		return [-1, -1]
		
func _pay_player(win, num):
	var coef = 0
	if num == 3 and win == 3:
		coef = 20
		$particule_casino.play()
	elif num == 3:
		coef = 10
		$particule_casino.play()
		
	
	elif num == 2 and win == 3:
		coef = 5
	elif num == 2:
		coef = 2
	
	GAME.emit_signal("add_FCC", bet * coef)
	QUETE.emit_signal("new_victoir", QUETE.GameMachine.SloteMachine)

func _kill():
	killing = true 
	$AnimationPlayer.play("kill")


func _on_animation_player_animation_finished(_anim_name):
	$HUD/HUD/VideoStreamPlayer.set_visible(true)
	$HUD/HUD/VideoStreamPlayer.play()

func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://Scenes/lose.tscn")


func _on_button_2_button_down():
	if $HUD/HUD/quete.state == 0:
		$queteAnimation.play("quete_open")
		$AudioStreamPlayer.play()
		$HUD/HUD/quete.state = 1
	else:
		$queteAnimation.play("quete_close")
		$HUD/HUD/quete.state = 0
		$AudioStreamPlayer.play()
		
		
