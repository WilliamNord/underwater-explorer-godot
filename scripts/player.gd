extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

var is_swimming = false

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	
	if is_swimming:
		velocity.y = move_toward(velocity.y, 0, 200 * delta)
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta


	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_swimming:
		if Input.is_action_pressed("ui_up"):
			velocity.y = -150
		elif Input.is_action_pressed("ui_down"):
			velocity.y = 150

	move_and_slide()

func in_water_gravity():
	print("player in water")
	is_swimming = true
	if is_swimming == true:
		print("grav is zero")
	
