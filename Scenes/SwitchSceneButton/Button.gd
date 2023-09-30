extends TextureButton

@export var targetScene : String = ""


func _on_pressed():
	$AudioStreamPlayer2D.play()
	if !GAME.gameOver or get_name().contains('marc'):
		Transit.change_scene_to_file(targetScene, 0.2)
