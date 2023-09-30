extends Node2D

@onready var camera = $Camera2D 
var target = "shop"

var kill_just = false

@onready var light = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.kill.connect(_kill)
	$CanvasLayer/Control/VideoStreamPlayer.finished.connect(home)

func _kill():
	GAME.gameOver = true
	GAME.sync()
	$CanvasLayer/Control/VideoStreamPlayer.set_visible(true)
	$CanvasLayer/Control/VideoStreamPlayer.play()

func home():
	get_tree().change_scene_to_file("res://Scenes/lose.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GAME.gameOver:
		if !kill_just:
			kill_just = true
			DialogueManager.show_example_dialogue_balloon(load("res://dialogue/richard.dialogue"), "PlusDeTemps")		

	if target == 'shop':
		camera.translate(Vector2((242 - camera.position.x)/10, 0))
		$CanvasLayer/Control/SwitchButton.set_visible(true)
		$CanvasLayer/Control/SwitchButton2.set_visible(false)
		$CanvasLayer/Control/Button3.set_visible(false)
		if !GAME.has_talk_to_richard:
			$CanvasLayer/Control/pre.set_visible(false)
		else: 
			$CanvasLayer/Control/pre.set_visible(true)			
	else :
		camera.translate(Vector2((-1058 - camera.position.x)/10, 0))
		$CanvasLayer/Control/SwitchButton.set_visible(false)
		$CanvasLayer/Control/SwitchButton2.set_visible(true)
		$CanvasLayer/Control/Button3.set_visible(true)
		
	if randi_range(1,7) == 5:
		light.set_energy(randf_range(0, 0.75))
	
	

func _on_button_button_down():
	$AudioStreamPlayer2D.play()
	if !GAME.gameOver:	
		if target == "shop":
			target = "colect"
		else:
			target = "shop"


func _on_richard_button_down():
	$AudioStreamPlayer2D.play()
	if !GAME.gameOver:
		if target == "shop":
			DialogueManager.show_example_dialogue_balloon(load("res://dialogue/richard.dialogue"), "start")
		else:
			DialogueManager.show_example_dialogue_balloon(load("res://dialogue/bilyBody.dialogue"), "start")
			

func _on_button_2_button_down():
	if $CanvasLayer/Control/quete.state == 0:
		$queteAnimation.play("quete_open")
		$AudioStreamPlayer.play()
		$CanvasLayer/Control/quete.state = 1
	else:
		$AudioStreamPlayer.play()
		$queteAnimation.play("quete_close")
		$CanvasLayer/Control/quete.state = 0
		
var open_book = false

func _on_button_3_button_down():
	$CanvasLayer/Control/TextureRect3.set_visible(true)

func _on_button_3_mouse_entered():
	$AnimatedSprite2D.play("HOVER")


func _on_button_3_mouse_exited():
	$AnimatedSprite2D.play("NORMAL")


func _on_texture_rect_3_button_down():
		$CanvasLayer/Control/TextureRect3.set_visible(false)
