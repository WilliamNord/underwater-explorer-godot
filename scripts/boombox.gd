extends Area2D

@onready var label: Label = $Label
var can_interact = false

var songs: Array[AudioStream] = []
var song_names: Array[String] = []
var current_song_index: int = 0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


@onready var popup_scene = load("res://scenes/music_popup.tscn")
var current_popup = null

func _ready() -> void:
	label.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact == true:
		if current_popup == null:
			current_popup = popup_scene.instantiate()
			current_popup.z_index = 100
			add_child(current_popup)

	if not audio_stream_player_2d.playing and songs.size() > 0:
		next_song()
		audio_stream_player_2d.play()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = true
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = false
		can_interact = false
		if current_popup:
			current_popup.queue_free()
			current_popup = null

func load_songs():
	songs.append(preload("res://audio/music/geoffharvey-tropical-coconut-island-367671.mp3"))
	song_names.append("tropical coconut island")
	
	songs.append(preload("res://audio/music/musictown-reggae-island-fun-109330.mp3"))
	song_names.append("musictown-reggae")
	
	songs.append(preload("res://audio/music/tech_oasis-tropical-music-island-breeze-216656.mp3"))
	song_names.append("tech oasis")
	
	songs.append(preload("res://audio/music/treasure-beach-reggae-327069.mp3"))
	song_names.append("treasure beach")

func next_song() -> void:
	current_song_index += 1
	if current_song_index >= songs.size():
		current_song_index = 0
		
	audio_stream_player_2d.stream = songs[current_song_index]
