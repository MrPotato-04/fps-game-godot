extends Camera
#const RAY_LENGTH = 1000
#onready var camera: Camera = $Player_Camera

#func _ready():
#	pass # Replace with function body.



#func _physics_process(delta):
#	if Input.is_action_just_pressed("primary_fire"):
#		var direct_state = get_world().direct_space_state
#		var collision = direct_state.intersect_ray(transform.origin, Vector3(0,0,-200))
#		
#		if collision:
#			print(collision.position)
	
