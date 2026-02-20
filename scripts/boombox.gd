extends Area2D

@onready var label: Label = $Label
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var songs: Array[AudioStream] = []
var song_names: Array[String] = []

var current_song_index: int = 0
var is_playing: bool = true
var can_interact: bool = false

@onready var popup_scene = preload("res://scenes/music_popup.tscn")
var popup: MusicPopup = null


func _ready() -> void:
	load_songs()
	
	if songs.size() > 0:
		audio_player.stream = songs[0]
		audio_player.play()
	
	label.visible = false
	
	audio_player.finished.connect(_on_song_finished)
	create_popup()


func load_songs() -> void:
	songs.append(preload("res://audio/music/geoffharvey-tropical-coconut-island-367671.mp3"))
	song_names.append("Tropical Coconut Island")

	songs.append(preload("res://audio/music/musictown-reggae-island-fun-109330.mp3"))
	song_names.append("Musictown Reggae")

	songs.append(preload("res://audio/music/tech_oasis-tropical-music-island-breeze-216656.mp3"))
	song_names.append("Tech Oasis")

	songs.append(preload("res://audio/music/treasure-beach-reggae-327069.mp3"))
	song_names.append("Treasure Beach")


func create_popup() -> void:
	popup = popup_scene.instantiate()
	popup.visible = false
	popup.z_index = 100
	
	get_tree().root.add_child(popup)
	
	popup.set_song_list(song_names)
	popup.song_changed.connect(_on_song_changed)
	popup.play_pause_toggled.connect(_on_play_pause_toggled)
	popup.close_requested.connect(_on_close_requested)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		toggle_popup()


func toggle_popup() -> void:
	if popup.visible:
		popup.visible = false
	else:
		popup.global_position = global_position + Vector2(-175, -350)
		popup.visible = true
		popup.sync_state(current_song_index, is_playing)


func _on_song_changed(index: int) -> void:
	current_song_index = index
	
	audio_player.stop()
	audio_player.stream = songs[current_song_index]
	
	if is_playing:
		audio_player.play()


func _on_play_pause_toggled(should_play: bool) -> void:
	is_playing = should_play
	
	if is_playing:
		audio_player.play()
	else:
		audio_player.stop()


func _on_song_finished() -> void:
	if not is_playing:
		return
	
	current_song_index += 1
	if current_song_index >= songs.size():
		current_song_index = 0
	
	audio_player.stream = songs[current_song_index]
	audio_player.play()
	
	if popup.visible:
		popup.sync_state(current_song_index, is_playing)


func _on_close_requested() -> void:
	popup.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = true
		can_interact = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.visible = false
		can_interact = false
		popup.visible = false
