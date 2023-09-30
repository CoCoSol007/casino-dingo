extends Node2D

@onready var rect = $CanvasLayer/Control/ColorRect

func _ready():
	$CanvasLayer/Control/marc.connect("button_down", _on_texture_button_button_down)
	$AnimationPlayer.play(get_name())

func _on_texture_button_button_down():
	GAME.new_save()
	Transit.change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_animation_player_animation_finished(_anim_name):
	rect.queue_free()
