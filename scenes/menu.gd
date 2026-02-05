extends Control


@onready var v_box_container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	v_box_container.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
