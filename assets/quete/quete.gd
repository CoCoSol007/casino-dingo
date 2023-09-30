extends Control

var state = 0

@onready var pro = $process
@onready var info = $info

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var pro_text = str(QUETE.num_task) + "/" + str(QUETE.goal_num_task)
	if QUETE.current_quete == 0 :
		pro_text = ""
	pro.set_text(pro_text)
	info.set_text(get_info(QUETE.current_quete))
	
func get_info(num):
	if num == 0: 
		return "Tu n'as pas de quete, vas voir BilyBoy"
	elif num == 1: 
		return "200 jeton : gagner 2 fois d'affiler au Black Jack"
	elif num == 2: 
		return "1 000 jeton : gagner 5 fois d'affiler au Black Jack"
	elif num == 3: 
		return "5 000 jeton : gagner 7 fois d'affiler au Black Jack"
	elif num == 4: 
		return "2000 jeton : gagner 2 fois d'affiler a la Machine a Sous"
	elif num == 5: 
		return "10 000 jeton : gagner 5 fois d'affiler a la Machine a Sous"
	elif num == 6: 
		return "50 000 jeton : gagner 7 fois d'affiler a la Machine a Sous"
	
