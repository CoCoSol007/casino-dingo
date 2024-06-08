extends Node2D

func _on_texture_button_button_down():
	GAME.new_save()
	Transit.change_scene_to_file("res://Scenes/MainMenu.tscn")



func _ready():
	if GAME.first_co and GAME.real_first_co:
		GAME.real_first_co = false
		get_tree().change_scene_to_file.bind("res://assets/cinematique/cinematique_start.tscn").call_deferred()
	elif GAME.first_co:
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/start.dialogue"), "start")
		GAME.change_first_co(false)


func _on_button_button_down():
	if $HUD/HUD/quete.state == 0:
		$queteAnimation.play("quete_open")
		$HUD/HUD/quete.state = 1
		$AudioStreamPlayer.play()
	else:
		$queteAnimation.play("quete_close")
		$HUD/HUD/quete.state = 0
		$AudioStreamPlayer.play()		
