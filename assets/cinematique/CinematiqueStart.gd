extends Node2D

var state = 0


func _process(_delta):
	if GAME.first_co:
		if state == 0: 
			state = 1
			$HUD/HUD/VideoStreamPlayer.set_visible(true)
			$HUD/HUD/TextureRect.set_visible(true)
			$HUD/HUD/VideoStreamPlayer.play()
		elif state == 2: 
			state = 3
			$HUD/HUD/VideoStreamPlayer2.set_visible(true)
			$HUD/HUD/VideoStreamPlayer2.play()

func _on_video_stream_player_2_finished():
	$HUD/HUD/VideoStreamPlayer2.queue_free()
	$HUD/HUD/TextureRect.queue_free()
	state += 1
	Transit.change_scene_to_file("res://Scenes/MainMenu.tscn", 0.9)
	


func _on_video_stream_player_finished():
	print('o')
	$HUD/HUD/VideoStreamPlayer.queue_free()
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/richard.dialogue"), "phone")
	await DialogueManager.dialogue_ended
	state += 1

