extends Control

@onready var button_container: VBoxContainer = $button_container


var options = load("res://scenes/options.tscn")

func _ready() -> void:
	button_container.grab_focus()
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_pressed() -> void:
	var options_menu = options.instantiate()
	add_child(options_menu)

func _on_quit_pressed() -> void:
	get_tree().quit()
