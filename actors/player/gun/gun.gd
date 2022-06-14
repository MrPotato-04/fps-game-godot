extends Node

onready var this: AnimationPlayer = $AnimationPlayer
onready var gun_anim_states: Array =  ["idle","Hide","Draw","Reload","Shoot"]
onready var gun_action_key_groups: Array = ["primary_fire", "secondary_fire", "lower_gun", "reload"]

onready var audio_parrent: MeshInstance = $Sketchfab_model/bf2d975137f8485789cd58bed6e8bc8dfbx/Object_2/RootNode/Object_4/Skeleton/Object_10
onready var player_1: AudioStreamPlayer3D = $Sketchfab_model/bf2d975137f8485789cd58bed6e8bc8dfbx/Object_2/RootNode/Object_4/Skeleton/Object_10/AudioStreamPlayer3D
onready var players: Array = [player_1]
onready var stream = load("res://assets/audio/gunshots/9_mm.wav")


onready var timeout: Timer = $Sketchfab_model/bf2d975137f8485789cd58bed6e8bc8dfbx/Object_2/RootNode/Object_4/Skeleton/Object_10/Timer

onready var gun_state = gun_anim_states[0]

func _ready():
	_create_audio_players(9)

func _unhandled_input(event):
	for action in gun_action_key_groups:
		if event.is_action(action):
			_anim_gun(action, event)


func _anim_gun(action_press, event):
	this.set_speed_scale(1)
	#TODO add auto fire on pistol (aka Hold mouse)
	match action_press:
		"primary_fire":
			if timeout.is_stopped():
				this.set_speed_scale(4)
				gun_state = gun_anim_states[4]
				this.play(gun_state)
				for player in players:
					if !player.is_playing():
						player.play()
						break
				timeout.start();
			
		"secondary_fire":
			pass
		"reload":
			gun_state = gun_anim_states[3]
			this.play(gun_state)
		"lower_gun":
			if event.is_action_pressed("lower_gun"):
				if gun_state != gun_anim_states[1]:
					gun_state = gun_anim_states[1]
		
				elif gun_state == gun_anim_states[1]:
					gun_state = gun_anim_states[2]
				this.play(gun_state)
	
func _create_audio_players(num_of_players):
	for i in num_of_players:
		var player = player_1.duplicate()
		audio_parrent.add_child(player)
		players.append(player)
		
