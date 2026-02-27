extends Node2D

@onready var darkness_light: DirectionalLight2D = $darkness_light
@onready var sun: PointLight2D = $sun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	darkness_light.enabled = true
	sun.enabled = true
	
	var bounds_component = $Ocean/BoundsComponent
	var player = $player
	
	#kobler signal from bounds_component til spiller sin _on_bounds_ready()
	bounds_component.bounds_ready.connect(player._on_bounds_ready)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
