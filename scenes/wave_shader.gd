extends Area2D

@export var wave_width: int = 100
@export var wave_height: int = 100

@onready var main_wave: Sprite2D = $main_wave
@onready var sub_wave: Sprite2D = $sub_wave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_wave.region_rect = Rect2(0,0,wave_width,wave_height)
	sub_wave.region_rect = Rect2(0,0,wave_width,wave_height)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
