extends Area2D

@onready var label: Label = $Label

var can_pick_up = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = true
		can_pick_up = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = false
		can_pick_up = false
