extends Control

func _ready():
	
	GAME.connect("update_money", _update_money) # Replace with function body.
	$Label.set_text(str(GAME.get_money()))
	GAME.connect("update_FCC", _update_FCC) # Replace with function body.
	$Label2.set_text(str(GAME.get_FCC()))

func _update_money(new_value):
	$Label.set_text(str(new_value))

func _update_FCC(new_value):
	$Label2.set_text(str(new_value))

