class_name UnderwaterAudioComponent
extends Node

@export var underwater_bus: String = "Underwater"
@export var normal_bus: String = "Master"

func _ready():
	get_parent().entered_water.connect(_on_entered_water)
	get_parent().exited_water.connect(_on_exited_water)

func _on_entered_water():
	for ap in get_tree().get_nodes_in_group("music_players"):
		ap.bus = underwater_bus

func _on_exited_water():
	for ap in get_tree().get_nodes_in_group("music_players"):
		ap.bus = normal_bus
