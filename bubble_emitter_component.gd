extends Node

var bubble = preload("res://scenes/bubble.tscn").instantiate()

func _ready() -> void:
	spawn_bubble()

func spawn_bubble():
	add_child(bubble)
