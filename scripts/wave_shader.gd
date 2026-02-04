extends Area2D

@export var ocean_width: int = 3355
@export var wave_height: int = 100 # ikke rør O_O
@export var auto_width: bool = true

@onready var main_wave: Sprite2D = $main_wave
@onready var sub_wave: Sprite2D = $sub_wave

@onready var ocean_layer_top: Sprite2D = $Ocean_layer_top
@onready var main_wave_2: Sprite2D = $main_wave2

func setup_wave(sprite: Sprite2D):
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, ocean_width, wave_height)
	sprite.centered = true


func _ready() -> void:
	if auto_width:
		var ocean = get_parent().get_parent().get_node("Ocean")
		global_position.x = ocean.get_node("CollisionShape2D").global_position.x
		ocean_width = ocean.get_node("CollisionShape2D").shape.size.x
		
	setup_wave(main_wave)
	setup_wave(sub_wave)

	
