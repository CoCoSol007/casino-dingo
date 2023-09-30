extends AnimatedSprite2D

@onready var timer = $Timer

var state = 'HAPPY' 
var time = 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	PERSONNAGE.connect("change_state", change_state)
	clignement()
	
func update_anim():
	play(state+str(time))
	
func clignement():
	while true:
		time = 2
		update_anim()
		timer.start(randf_range(0.2, 0.3))
		await timer.timeout
		time = 1
		update_anim()
		timer.start(randf_range(2, 3))
		await timer.timeout
	
func change_state(target, new_state):
	if target == get_name():
		state = new_state
	
