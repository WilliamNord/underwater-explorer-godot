extends CharacterBody2D

# Landvariabler
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var MAX_SPEED = 100

# Svømmevariabler
@export var SWIM_ACCELERATION = 1000.0
@export var SWIM_MAX_SPEED = 500.0
@export var SWIM_FRICTION = 250.0

#signaler
signal entered_water
signal exited_water

#akselerasjon
var acceleration := 2.5
var last_direction: float

#variabel
var is_swimming = false

#state
var state = "idle"

@onready var bubbles: GPUParticles2D = $bubbles

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const WATER_SPLASH = preload("res://audio/sound effects/water_splash.mp3")
 
@onready var shadow_light: PointLight2D = $shadow_light
@onready var sprite_light: PointLight2D = $sprite_light

@onready var camera: Camera2D = $Camera2D

var ocean_rect: Rect2

#player sprite
@onready var body_animation: AnimatedSprite2D = $player

#arm sprite & animasjon
@onready var arm: Sprite2D = $player/arm
@onready var animation_player_arm: AnimationPlayer = $player/arm/AnimationPlayerArm

#collision shape
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	add_to_group("player")

#en funksjon for å stoppe kameraet fra å gå ut av verden
#dinne limitene er dynamiske og endrer seg automatisk med havet og størrelsen
#kobles sammen av World_setup.gd 
func _on_bounds_ready(rect: Rect2):
	ocean_rect = rect
	camera.limit_left   = rect.position.x
	#camera.limit_top    = rect.position.y
	camera.limit_right  = rect.end.x
	camera.limit_bottom = rect.end.y


func _physics_process(delta: float) -> void:
	
	if is_swimming:
		handle_swimming(delta)
	else:
		handle_land_movement(delta)
	
	if ocean_rect != Rect2():
		position.x = clamp(position.x, ocean_rect.position.x, ocean_rect.end.x)
		position.y = clamp(position.y, position.y, ocean_rect.end.y)
	
	move_and_slide()


func handle_swimming(delta: float) -> void:
	var input_x = Input.get_axis("ui_left", "ui_right")
	var input_y = Input.get_axis("ui_up", "ui_down")
	var input = Vector2(input_x, input_y)

	var target_angle = input.angle()

	#roterer spilleren og collisionshape til retningen
	if input.length() > 0.05:
		rotate_player(delta, body_animation, target_angle + PI / 2, 10.0)
		rotate_player(delta, collision_shape, target_angle + PI / 2, 10.0)
	else:
		rotate_player(delta, body_animation, 0.0, 1.0)
		rotate_player(delta, collision_shape, 0.0, 1.0)
		

	if input_x != 0:
		velocity.x = move_toward(velocity.x, input_x * SWIM_MAX_SPEED, SWIM_ACCELERATION * delta)
		body_animation.flip_h = input_x < 0
		body_animation.play("walk")
		
		if input_x > 0:
			animation_player_arm.play("swim_right")
		elif input_x < 0:
			animation_player_arm.play("swim_left")
		else:
			animation_player_arm.play("idle")
	else:
		velocity.x = move_toward(velocity.x, 0, SWIM_FRICTION * delta)

	if input_y != 0:
		velocity.y = move_toward(velocity.y, input_y * SWIM_MAX_SPEED, SWIM_ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, SWIM_FRICTION * delta)

func handle_land_movement(delta: float) -> void:
		
	body_animation.rotation_degrees = lerp_angle(
		body_animation.rotation_degrees,
		0.0,
		10.0 * delta
	)

	# gravitasjon
	if not is_on_floor():
		velocity += get_gravity() * delta

	# hopping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# horisontal bevegelse
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
		body_animation.flip_h = direction < 0
		state = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		state = "idle"

	if not is_on_floor():
		state = "jump"

func rotate_player(delta: float, part, target, speed):
	part.rotation = lerp_angle(
		part.rotation,
		target,
		delta * speed
	)

func in_water_gravity():
	print("player in water")
	is_swimming = true
	audio_stream_player_2d.stream = WATER_SPLASH
	audio_stream_player_2d.volume_db = -10.0
	audio_stream_player_2d.play()
	
	bubbles.emitting = true
	
	shadow_light.enabled = true
	sprite_light.enabled = true
	
	entered_water.emit()
	
func out_water_gravity():
	print("player out of water")
	is_swimming = false 
	
	shadow_light.enabled = false
	sprite_light.enabled = false
	
	exited_water.emit()

#funksjon for akselerasjon og endring av retning
func calculate_speed(direction: float) -> void:
	if last_direction == direction: 
		SPEED += acceleration
	else:
		SPEED = 0
	if SPEED > MAX_SPEED:
		SPEED = MAX_SPEED
