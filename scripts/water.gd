extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var size_x: float
@export var size_y: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#collision_shape_2d.shape.size = Vector2(size_x,size_y)
	print("Water area ready at position: ", global_position)
	print("Monitoring: ", monitoring)
	print("Monitorable: ", monitorable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	print("player in water")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.in_water_gravity()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.out_water_gravity()
