extends Node

signal change_state(target, state)

func set_state(target, state):
	PERSONNAGE.emit_signal("change_state",target, state)
