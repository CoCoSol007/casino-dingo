@tool
extends EditorPlugin

func _enable_plugin():
	add_autoload_singleton("Transit", "res://addons/transit/Transit.tscn")


func _disable_plugin():
	remove_autoload_singleton("Transit")
