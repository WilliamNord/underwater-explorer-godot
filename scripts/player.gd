extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var MAX_SPEED = 100

var acceleration := 2.5
var last_direction: float

var is_swimming = false

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	
	if is_swimming:
		velocity.y = move_toward(velocity.y, 0, 400 * delta)
		velocity.x = move_toward(velocity.x, 0, 400 * delta)
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	elif is_swimming:
		pass
	else:
		if not is_swimming:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		
	if is_swimming:
		if Input.is_action_pressed("ui_up"):
			velocity.y = -200 
		elif Input.is_action_pressed("ui_down"):
			velocity.y = 200 
		elif Input.is_action_pressed("ui_right"):
			velocity.x = 200 
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -200
	
	if is_swimming:
		velocity.x = clamp(velocity.x, -200, 200)



	move_and_slide()

func in_water_gravity():
	print("player in water")
	is_swimming = true
	if is_swimming == true:
		print("grav is zero")
		
func out_water_gravity():
	print("player out of water")
	is_swimming = false 
	if is_swimming == true: 
		print("grav is zero")
	else: 
		print("grav is on")

func calculate_speed(direction: float) -> void:
	if last_direction == direction: 
		SPEED += acceleration
	else:
		SPEED = 0
	
	if SPEED > MAX_SPEED:
		SPEED = MAX_SPEED
