extends Area2D

@onready var label: Label = $Label
var can_interact = false


@onready var popup_scene = load("res://scenes/popup.tscn")

func _ready() -> void:
	label.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact == true:
		var new_pop_up = popup_scene.instantiate()
		add_child(new_pop_up)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = true
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = false
		can_interact = false
		get_node("new_pop_up").queue_free()
