extends Node



onready var audio_parrent: MeshInstance = $Sketchfab_model/bf2d975137f8485789cd58bed6e8bc8dfbx/Object_2/RootNode/Object_4/Skeleton/Object_10
onready var player_1: AudioStreamPlayer3D = $Sketchfab_model/bf2d975137f8485789cd58bed6e8bc8dfbx/Object_2/RootNode/Object_4/Skeleton/Object_10/AudioStreamPlayer3D
onready var _AnimationPlayer: AnimationPlayer = $AnimationPlayer
onready var ammo_count_text: RichTextLabel = $"./../Player_Camera/CanvasLayer/RichTextLabel2"

onready var players: Array = [player_1]
onready var gun_anim_states: Array =  ["idle","Hide","Draw","Reload","Shoot"]
onready var gun_action_key_groups: Array = ["primary_fire", "secondary_fire", "lower_gun", "reload"]
onready var gun_anim_state = gun_anim_states[0]
#onready var stream = load("res://assets/audio/gunshots/9_mm.wav")

#GUN Vars
export var fire_rate = 0.35
export var clip_size = 12
export var reload_rate = 3.767 + 0.1

var current_ammo = clip_size
var can_fire = true





func _ready():
	_create_audio_players(9)
	
func _process(delta):
	if Input.is_action_just_pressed("primary_fire"):
		_AnimationPlayer.set_speed_scale(3)		
		gun_anim_state = gun_anim_states[4]
		if current_ammo > 0 and can_fire:
			can_fire = false
			
			for player in players:
				if !player.is_playing():
					player.play()
					break
			
			current_ammo -= 1
			ammo_count_text.set_text(str(current_ammo,"/12"))
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true
		else:
			can_fire = false
		_AnimationPlayer.play(gun_anim_state)
	
	if Input.is_action_just_pressed("secondary_fire"):
			pass
	
	if Input.is_action_just_pressed("reload"):
		_AnimationPlayer.set_speed_scale(1)
		gun_anim_state = gun_anim_states[3]
		_AnimationPlayer.play(gun_anim_state)
	
	if Input.is_action_just_pressed("lower_gun"):
		_AnimationPlayer.set_speed_scale(1)
		if gun_anim_state != gun_anim_states[1]:
			gun_anim_state = gun_anim_states[1]
			
		elif gun_anim_state == gun_anim_states[1]:
			gun_anim_state = gun_anim_states[2]
		_AnimationPlayer.play(gun_anim_state)

	
func _create_audio_players(num_of_players):
	for i in num_of_players:
		var player = player_1.duplicate()
		audio_parrent.add_child(player)
		players.append(player)
		
