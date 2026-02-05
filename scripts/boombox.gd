extends Area2D

@onready var label: Label = $Label
var can_interact = false

func _ready() -> void:
	label.visible = false

func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = true
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = false
		can_interact = false
