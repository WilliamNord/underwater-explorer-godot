extends Node
class_name bubble_emitter_component

var bubble = preload("res://scenes/bubble.tscn").instantiate()

func _ready() -> void:
	self.add_to_group("bubble_emitter")

func spawn_bubble():
	bubble.global_position = get_parent().global_position
	get_tree().current_scene.add_child(bubble)
