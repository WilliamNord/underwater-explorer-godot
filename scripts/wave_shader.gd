extends Area2D

@export var wave_width: int = 3355
@export var wave_height: int = 100
@export var auto_width: bool = true

@onready var main_wave: Sprite2D = $main_wave
@onready var sub_wave: Sprite2D = $sub_wave

func _ready() -> void:
	if auto_width:
		var ocean = get_parent().get_node("Ocean")
		global_position.x = ocean.get_node("CollisionShape2D").global_position.x
		wave_width = ocean.get_node("CollisionShape2D").shape.size.x
	
	main_wave.region_enabled = true
	main_wave.region_rect = Rect2(0, 0, wave_width, wave_height)
	main_wave.centered = true
	
	sub_wave.region_enabled = true
	sub_wave.region_rect = Rect2(0, 0, wave_width, wave_height)
	sub_wave.centered = true
