extends Spatial



onready var audio_parrent: MeshInstance = $Sketchfab_model/bf2d975137f8485789cd58bed6e8bc8dfbx/Object_2/RootNode/Object_4/Skeleton/Object_10
onready var player_1: AudioStreamPlayer3D = $Sketchfab_model/bf2d975137f8485789cd58bed6e8bc8dfbx/Object_2/RootNode/Object_4/Skeleton/Object_10/AudioStreamPlayer3D
onready var _AnimationPlayer: AnimationPlayer = $AnimationPlayer
onready var ammo_count_text: RichTextLabel = $"./../CanvasLayer/RichTextLabel2"
onready var player_camera: Camera = $"./../../Player_Camera"
onready var gun: Spatial = $"./../Gun" 
onready var raycaster: RayCast = $RayCast
onready var b_decal = preload("res://actors/player/gun/BulletDecal.tscn")


onready var _gunshot = load("res://assets/audio/gunshots/9_mm_edit.wav")
onready var _gunshot_empty = load("res://assets/audio/gunshots/empty-gun-shot.wav")

onready var players: Array = [player_1]
onready var gun_anim_states: Array =  ["idle","Hide","Draw","Reload","Shoot"]
onready var gun_action_key_groups: Array = ["primary_fire", "secondary_fire", "lower_gun", "reload"]
onready var gun_anim_state = gun_anim_states[0]
var gun_lowerd: bool =  false

var anim_finished: String = "idle"
#onready var stream = load("res://assets/audio/gunshots/9_mm.wav")

#GUN Vars
export var fire_rate = 0.35
export var clip_size = 12
export var reload_rate = 3.767 + 0.1

var current_ammo = clip_size
var can_fire = true
var ads = false
var ads_translation
var gun_origin  # set in ready otherwise parent is not initalized
var ads_position = Vector3(-0.107,-1.542,-0.30)
var gun_translation

var scene

func _ready():
	gun_origin = get_parent().get_node("Gun").get_translation() #see comment at var init
	_create_audio_players(20)
	_AnimationPlayer.connect("animation_finished", self, "_anim_finished")
	scene = get_tree().get_root().get_node("./Map/objects")
	print(scene)
func _anim_finished(name: String):
	anim_finished = name
	gun_anim_state = gun_anim_states[0]

func _unhandled_input(event):
	if event.is_action_pressed("secondary_fire"):
		ads = true
	if event.is_action_released("secondary_fire"):
		ads = false

	
func _process(delta):
	if ads:
		gun.transform.origin = transform.origin.linear_interpolate(ads_position, 20 * delta)
	if !ads:
		gun.transform.origin = transform.origin.linear_interpolate(gun_origin, 20 * delta)

	if gun_anim_state == gun_anim_states[0]:
		if Input.is_action_just_pressed("primary_fire"):
			_shoot()
						
		
		if Input.is_action_just_pressed("reload"):
			_AnimationPlayer.set_speed_scale(1)
			gun_anim_state = gun_anim_states[3]
			_AnimationPlayer.play(gun_anim_state)
			yield(get_tree().create_timer(3.667), "timeout")
			current_ammo = clip_size
			ammo_count_text.set_text(str(current_ammo,"/12"))
		
		if Input.is_action_just_pressed("lower_gun"):
			_AnimationPlayer.set_speed_scale(1)
			if gun_lowerd == false:
				gun_anim_state = gun_anim_states[1]
				gun_lowerd = true
			elif gun_lowerd == true:
				gun_anim_state = gun_anim_states[2]
				gun_lowerd = false
			_AnimationPlayer.play(gun_anim_state)

func _shoot():
	if current_ammo > 0 and can_fire:
				_AnimationPlayer.set_speed_scale(3)		
				gun_anim_state = gun_anim_states[4]
				can_fire = false
				for player in players:
					if !player.is_playing():
						player.set_stream(_gunshot)
						player.play()
						_AnimationPlayer.play(gun_anim_state)
						_cast_bullet_ray()
						break
				
				current_ammo -= 1
				ammo_count_text.set_text(str(current_ammo,"/12"))
				yield(get_tree().create_timer(fire_rate), "timeout")
				can_fire = true
	elif current_ammo == 0:
		for player in players:
			if !player.is_playing():
				player.set_stream(_gunshot_empty)
				player.play()
				#_AnimationPlayer.play(gun_anim_state)
				break
func _cast_bullet_ray():
	var b_pos = raycaster.get_collision_point()
	var b = b_decal.instance()
	raycaster.get_collider().add_child(b)
	b.global_transform.origin = b_pos
	b.look_at(raycaster.get_collision_point() + raycaster.get_collision_normal(), Vector3.UP)

func _create_audio_players(num_of_players):
	for i in num_of_players:
		var player = player_1.duplicate()
		audio_parrent.add_child(player)
		players.append(player)
		
