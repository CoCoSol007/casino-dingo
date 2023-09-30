extends Node2D

var bet = 100
signal update_bet(value)
signal score_update(value)
signal npc_score_update(value)
@onready var Button_Sound = $Button_Sound

var is_playing = false
var npc_is_playing = false
var o = false
func get_bet(): return bet

var kill_just = false
var score = 0
var npc_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("score_update", _check_score)
	GAME.kill.connect(_kill)
	$HUD/HUD/loose.finished.connect(home)
	

func _process(_delta):
	if GAME.gameOver:
		if !kill_just:
			kill_just = true
			if GAME.get_money() == 0 and GAME.get_FCC() == 0:
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/Jack.dialogue"), "start")	
			else:
				DialogueManager.show_example_dialogue_balloon(load("res://dialogue/Jack.dialogue"), "PlusDeTemps")	

func _end_game():
	score = 0
	npc_score = 0
	$HUD/HUD/startbutton/CenterContainer/Label4.set_text("Start")
	$HUD/HUD/win.set_visible(false)	
	$HUD/HUD/lost.set_visible(false)	
	$HUD/HUD/DownBetButton.set_visible(true)
	$HUD/HUD/UpBetButton.set_visible(true)
	$HUD/HUD/Label3.set_visible(false)
	$HUD/HUD/Label4.set_visible(false)
	is_playing = false
	o = false
	npc_is_playing = false
	for n in $HUD/HUD/hand.get_children():
		$HUD/HUD/hand.remove_child(n)
		n.queue_free()
	for n in $HUD/HUD/npc_hand.get_children():
		$HUD/HUD/npc_hand.remove_child(n)
		n.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _check_score(value):
	if value > 21 :
		o = true
		PERSONNAGE.emit_signal("change_state","Jack", "HAPPY")		
		QUETE.emit_signal("new_defait", QUETE.GameMachine.BlackJack)		
		$HUD/HUD/lost.set_visible(true)		
		$Timer.start(2)
		await $Timer.timeout
		if GAME.get_money() <= 0 and GAME.get_FCC() <= 0:
			GAME.gameOver = true
			GAME.sync()
		_end_game()
		

func gen_new_cart():
	var cart = load("res://Scenes/ScripteGame/Playcart.tscn").instantiate()
	$HUD/HUD/hand.add_child(cart)
	score += min(cart.num, 10)
	emit_signal("score_update", score)
	
func npc_gen_new_cart():
	var cart = load("res://Scenes/ScripteGame/Playcart.tscn").instantiate()
	$HUD/HUD/npc_hand.add_child(cart)
	npc_score += min(cart.num, 10)
	emit_signal("npc_score_update", npc_score)



func _on_startbutton_button_down():
	Button_Sound.play()
	if o == false:
		if !is_playing:
			if GAME.get_FCC() - bet >= 0: 
				GAME.emit_signal("substract_FCC", bet)
				score = 0
				is_playing = true
				GAME.emit_signal("start_game")
				$HUD/HUD/startbutton/CenterContainer/Label4.set_text("Finished")
				$HUD/HUD/DownBetButton.set_visible(false)
				$HUD/HUD/UpBetButton.set_visible(false)
				$HUD/HUD/Label3.set_visible(true)
				gen_new_cart()
				gen_new_cart()
		elif !npc_is_playing:
			NPC_playing()
		
func _kill():
	$HUD/HUD/loose.set_visible(true)
	$HUD/HUD/loose.play()

func home():
	get_tree().change_scene_to_file("res://Scenes/lose.tscn")

func NPC_playing():
	$HUD/HUD/Label4.set_visible(true)
	npc_is_playing = true
	npc_gen_new_cart()
	npc_gen_new_cart()
	while score > npc_score and randi_range(1,5) != 2:
		$Timer.start(1)
		await $Timer.timeout
		npc_gen_new_cart()
	
	$Timer.start(1)
	await $Timer.timeout
	if npc_score > 21:
		$HUD/HUD/win.set_visible(true)
		PERSONNAGE.emit_signal("change_state","Jack", "ANGRY")
		QUETE.emit_signal("new_victoir", QUETE.GameMachine.BlackJack)
	elif score > npc_score:
		$HUD/HUD/win.set_visible(true)
		PERSONNAGE.emit_signal("change_state","Jack", "ANGRY")		
		QUETE.emit_signal("new_victoir", QUETE.GameMachine.BlackJack)
		
	else:
		$HUD/HUD/lost.set_visible(true)		
		PERSONNAGE.emit_signal("change_state","Jack", "HAPPY")
		QUETE.emit_signal("new_defait", QUETE.GameMachine.BlackJack)
		if GAME.get_money() <= 0 and GAME.get_FCC() <= 0:
			GAME.gameOver = true
			GAME.sync()
		
		
	$Timer.start(3)
	await $Timer.timeout
	if npc_score > 21:
		GAME.emit_signal("add_FCC", bet * 3)
	elif score > npc_score:
		GAME.emit_signal("add_FCC", bet * 3)
	_end_game()


 


func _on_up_bet_button_button_down():
	bet += 100
	emit_signal("update_bet", bet)
	Button_Sound.play()
	
func _on_down_bet_button_button_down():
	if bet-100 > 0: 
		bet -= 100
		emit_signal("update_bet", bet)
		Button_Sound.play()


func _on_pioche_button_button_down():
	if o == false:
		if is_playing and !npc_is_playing:
			gen_new_cart()
			$playcart.play()


func _on_button_button_down():
	if $HUD/HUD/quete.state == 0:
		$queteAnimation.play("quete_open")
		$playcart.play()
		$HUD/HUD/quete.state = 1
	else:
		$queteAnimation.play("quete_close")
		$HUD/HUD/quete.state = 0
		$playcart.play()
		

