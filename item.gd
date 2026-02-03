extends Area2D
@onready var label: Label = $Label
@onready var tile_map: TileMapLayer = $TileMapLayer
var can_pick_up = false
var item_name: String = ""

func _ready() -> void:
	label.visible = false
	
	# Les fra grid posisjon (juster hvis du maler andre steder)
	var tile_coords = tile_map.get_cell_atlas_coords(Vector2i(0, -1))
	
	print("Tile coords: ", tile_coords)
	
	# Match ALLE 16 atlas koordinater (4x4)
	match tile_coords:
		Vector2i(0, 0): item_name = "item_0_0"
		Vector2i(1, 0): item_name = "flaske"
		Vector2i(2, 0): item_name = "Item_2_0"
		Vector2i(3, 0): item_name = "Lyspære"
		Vector2i(0, 1): item_name = "Item_0_1"
		Vector2i(1, 1): item_name = "Item_1_1"
		Vector2i(2, 1): item_name = "Item_2_1"
		Vector2i(3, 1): item_name = "Chip"
		Vector2i(0, 2): item_name = "Item_0_2"
		Vector2i(1, 2): item_name = "Item_1_2"
		Vector2i(2, 2): item_name = "Item_2_2"
		Vector2i(3, 2): item_name = "Item_3_2"
		Vector2i(0, 3): item_name = "Item_0_3"
		Vector2i(1, 3): item_name = "Item_1_3"
		Vector2i(2, 3): item_name = "Item_2_3"
		Vector2i(3, 3): item_name = "Item_3_3"
		_: item_name = "Ukjent"
	
	print("Dette er en: " + item_name)
	
func _process(delta: float) -> void:
	if can_pick_up and Input.is_action_just_pressed("interact"):
		print("Plukket opp: " + item_name)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = true
		can_pick_up = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = false
		can_pick_up = false
