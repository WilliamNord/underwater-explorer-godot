extends Control

signal song_changed(song_index: int)
signal play_pause_toggled(is_playing: bool)
signal close_requested()

var current_song_index: int = 0
var song_list: Array[String] = []
var is_playing: bool = true


@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var song_label: Label = $Panel/MarginContainer/VBoxContainer/SongLabel
@onready var right: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/right
@onready var left: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/left
@onready var play_button: Button = $"Panel/MarginContainer/VBoxContainer/play button"
@onready var close_button: Button = $"Panel/MarginContainer/VBoxContainer/close button"


func _ready() -> void:
	# Koble til signal handlers
	left.pressed.connect(_on_left_pressed)
	right.pressed.connect(_on_right_pressed)
	play_button.pressed.connect(_on_play_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	update_ui()

func set_song_list(songs: Array[String]) -> void:
	song_list = songs
	current_song_index = 0
	update_ui()

func _on_left_pressed() -> void:
	current_song_index -= 1
	if current_song_index < 0:
		current_song_index = song_list.size() - 1
	
	song_changed.emit(current_song_index)
	update_ui()

func _on_right_pressed() -> void:
	current_song_index += 1
	if current_song_index >= song_list.size():
		current_song_index = 0
	
	song_changed.emit(current_song_index)
	update_ui()

func _on_play_pressed() -> void:
	is_playing = !is_playing
	play_pause_toggled.emit(is_playing)
		
	update_ui()

func _on_close_pressed() -> void:
	close_requested.emit()
	

func update_ui() -> void:
	# Oppdater play/pause button text
	if is_playing:
		play_button.text = "⏸ PAUSE"
	else:
		play_button.text = "▶ PLAY"
	
	# Oppdater song label (hvis den finnes)
	if song_label and song_list.size() > 0:
		song_label.text = song_list[current_song_index]
	elif song_label:
		song_label.text = "No songs loaded"
