extends Node
onready var player_1: AudioStreamPlayer3D = $AudioStreamPlayer3D
onready var players: Array = [player_1]

onready var timeout: Timer = $Timer

onready var stream = load("res://assets/audio/gunshots/9_mm.wav")

func _ready():
	_create_audio_players(9)
	
func _unhandled_input(event):
	if event.is_action_pressed("primary_fire"):
		
		

func _create_audio_players(num_of_players):
	for i in num_of_players:
		var player = player_1.duplicate()
		add_child(player)
		players.append(player)
		
