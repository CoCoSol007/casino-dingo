extends Control

func _ready():
	GAME.connect("update_FCC", _update_money) # Replace with function body.
	owner.connect("update_bet", _update_bet) # Replace with function body.
	$Label.set_text(str(GAME.get_FCC()))
	$Label2.set_text("Mise : " + str(owner.get_bet()))

func _update_money(new_value):
	$Label.set_text(str(new_value))

func _update_bet(new_value):
	$Label2.set_text("Mise : " + str(new_value))
