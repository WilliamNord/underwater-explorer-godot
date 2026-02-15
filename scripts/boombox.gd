extends Area2D

@onready var label: Label = $Label
var can_interact = false

var songs: Array[AudioStream] = []
var song_names: Array[String] = []
var current_song_index: int = 0
var is_paused: bool = false

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var popup_scene = preload("res://scenes/music_popup.tscn")
var current_popup = null

func _ready() -> void:
	load_songs()
	
	if songs.size() > 0:
		audio_stream_player_2d.stream = songs[0]
		audio_stream_player_2d.play()
		
	label.visible = false
	
	create_popup()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact == true:
		toggle_popup()
		
	if not audio_stream_player_2d.playing and songs.size() > 0 and not is_paused:
		next_song()
		audio_stream_player_2d.play()

func create_popup() -> void:
	current_popup = popup_scene.instantiate()
	current_popup.z_index = 100
	current_popup.visible = false
	
	get_tree().root.add_child(current_popup)
	
	current_popup.set_song_list(song_names)
	current_popup.song_changed.connect(_on_song_changed)
	current_popup.play_pause_toggled.connect(_on_play_pause_toggled)
	current_popup.close_requested.connect(close_popup)

func toggle_popup() -> void:
	if current_popup:
		if current_popup.visible:
			close_popup()
		else:
			current_popup.global_position = global_position + Vector2(-175, -350)
			open_popup()

func close_popup() -> void:
	if current_popup:
		current_popup.visible = false

func open_popup() -> void:
	if current_popup:
		current_popup.visible = true

func _on_song_changed(song_index: int) -> void:
	current_song_index = song_index
	audio_stream_player_2d.stream = songs[current_song_index]
	audio_stream_player_2d.play()
	is_paused = false

func _on_play_pause_toggled(is_playing: bool) -> void:
	if is_playing:
		audio_stream_player_2d.play()
		is_paused = false
	else:
		audio_stream_player_2d.stop()
		is_paused = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = true
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = false
		can_interact = false
		close_popup()

func load_songs() -> void:
	songs.append(preload("res://audio/music/geoffharvey-tropical-coconut-island-367671.mp3"))
	song_names.append("Tropical Coconut Island")
	
	songs.append(preload("res://audio/music/musictown-reggae-island-fun-109330.mp3"))
	song_names.append("Musictown Reggae")
	
	songs.append(preload("res://audio/music/tech_oasis-tropical-music-island-breeze-216656.mp3"))
	song_names.append("Tech Oasis")
	
	songs.append(preload("res://audio/music/treasure-beach-reggae-327069.mp3"))
	song_names.append("Treasure Beach")

func next_song() -> void:
	current_song_index += 1
	if current_song_index >= songs.size():
		current_song_index = 0
		
	audio_stream_player_2d.stream = songs[current_song_index]
	
	if current_popup and current_popup.visible:
		current_popup.current_song_index = current_song_index
		current_popup.update_ui()
