extends CharacterBody2D

# Landvariabler
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var MAX_SPEED = 100

# Svømmevariabler
@export var SWIM_ACCELERATION = 1000.0
@export var SWIM_MAX_SPEED = 500.0
@export var SWIM_FRICTION = 250.0

var acceleration := 2.5
var last_direction: float

var is_swimming = false

@onready var bubbles: GPUParticles2D = $bubbles

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const WATER_SPLASH = preload("res://audio/water_splash.mp3")

@onready var shadow_light: PointLight2D = $shadow_light
@onready var sprite_light: PointLight2D = $sprite_light


func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	
	if is_swimming:
		handle_swimming(delta)
	else:
		handle_land_movement(delta)
	
	move_and_slide()
	
func handle_swimming(delta: float) -> void:
	var input_x = Input.get_axis("ui_left", "ui_right")
	var input_y = Input.get_axis("ui_up", "ui_down")

	# hvis det er input, aksellerer i den retningen * SWIM_MAX_SPEED
	if input_x != 0:
		velocity.x = move_toward(velocity.x, input_x * SWIM_MAX_SPEED, SWIM_ACCELERATION * delta)
	else:
		# friksjon når ingen input
		velocity.x = move_toward(velocity.x, 0, SWIM_FRICTION * delta)
	
	if input_y != 0:
		velocity.y = move_toward(velocity.y, input_y * SWIM_MAX_SPEED, SWIM_ACCELERATION * delta)
	else:
		# friksjon når ingen input
		velocity.y = move_toward(velocity.y, 0, SWIM_FRICTION * delta)
		
func handle_land_movement(delta: float) -> void:
	# gravitasjon
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# horisontal bevegelse
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#if is_swimming:
		#velocity.y = move_toward(velocity.y, 0, 400 * delta)
		#velocity.x = move_toward(velocity.x, 0, 400 * delta)
	#else:
		#if not is_on_floor():
			#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#elif is_swimming:
		#pass
	#else:
		#if not is_swimming:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
#
		#
	#if is_swimming:
		#if Input.is_action_pressed("ui_up"):
			#velocity.y = -200 
		#elif Input.is_action_pressed("ui_down"):
			#velocity.y = 200 
		#elif Input.is_action_pressed("ui_right"):
			#velocity.x = 200 
		#elif Input.is_action_pressed("ui_left"):
			#velocity.x = -200
	#
	#if is_swimming:
		#velocity.x = clamp(velocity.x, -200, 200)


func in_water_gravity():
	print("player in water")
	is_swimming = true
	audio_stream_player_2d.stream = WATER_SPLASH
	audio_stream_player_2d.volume_db = -10.0
	audio_stream_player_2d.play()
	
	bubbles.emitting = true
	
	shadow_light.enabled = true
	sprite_light.enabled = true
		
func out_water_gravity():
	print("player out of water")
	is_swimming = false 
	
	shadow_light.enabled = false
	sprite_light.enabled = false

#funksjon for akselerasjon og endring av retning
func calculate_speed(direction: float) -> void:
	if last_direction == direction: 
		SPEED += acceleration
	else:
		SPEED = 0
	if SPEED > MAX_SPEED:
		SPEED = MAX_SPEED
