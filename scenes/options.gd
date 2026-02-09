extends Control

@onready var button: Button = $Button

@onready var button_container: VBoxContainer = $button_container

func _ready() -> void:
	button_container = get_parent().get_node("button_container")
	button_container.visible = false
	
func _on_button_pressed() -> void:
	button_container.visible = true
	queue_free()
