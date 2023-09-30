extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	QUETE.finished.connect(pop) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func pop():
	$AudioStreamPlayer.play()
	$particule_casino.play()
	$AnimatedSprite2D.play("start")
	set_visible(true)
	$Timer.start(3)
	await $Timer.timeout
	$AnimatedSprite2D.play_backwards("end")
	


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.get_animation() == "end":
		set_visible(false)
		

