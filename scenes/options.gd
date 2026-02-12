extends Control

@onready var button: Button = $Button


@onready var play: Button = $button_container/Play
@onready var options: Button = $button_container/Options
@onready var quit: Button = $button_container/Quit

@onready var button_container: VBoxContainer = $button_container


func _ready() -> void:
	get_parent().get_node("button_container").visible = false

func _on_button_pressed() -> void:
	get_parent().get_node("button_container").visible = true
	queue_free()
