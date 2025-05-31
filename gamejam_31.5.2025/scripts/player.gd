extends CharacterBody3D

@export var speed = 5
@export var can_jump : bool = false;
@export var jumpStrength = 5;

@export var player_cameras : Array[PlayerCamera];
var cur_cam_ind : int = 0;
func current_camera() -> PlayerCamera: return player_cameras[cur_cam_ind];

### General
func switch_camera(target_ind):
	if (cur_cam_ind != target_ind):
		current_camera().reset_rotation();
	cur_cam_ind = target_ind;
	(player_cameras[target_ind] as Camera3D).make_current();



### _physics_process
func process_movement(delta):
	# GRAVITY
	var gravity_vel = Vector3.ZERO;
	if not is_on_floor():
			gravity_vel += get_gravity() * delta
	elif can_jump and Input.is_action_just_pressed("Movement_Jump"):
			gravity_vel -= get_gravity().normalized() * jumpStrength
	if is_on_floor():
		var input_move_dir := Input.get_vector("Movement_Left", "Movement_Right", "Movement_Forward", "Movement_Backward")
		#var direction : Vector3 = current_camera().get_forward() * Vector3(input_move_dir.x, 0, input_move_dir.y);
		var direction : Vector3 = (current_camera().get_forward() * input_move_dir.y) + (current_camera().get_right() * input_move_dir.x)
		#.get_global_transform_interpolated().basis * Vector3(input_move_dir.x, 0, input_move_dir.y)
		velocity = direction * speed;
	velocity = velocity + gravity_vel;
	var pre_slide_vel = velocity;
	move_and_slide()

func _physics_process(delta):
	process_movement(delta);


### _Input
func process_key_input(event):
	if not event.pressed:
		match event.physical_keycode:
			KEY_1: switch_camera(0);
			KEY_2: switch_camera(1);
			KEY_3: switch_camera(2);
			KEY_4: switch_camera(3);
			KEY_5: switch_camera(4);
		#if (index != active_cam_index):
			#get_viewport().get_camera() RESET ROTATION

func process_mouse_input(relative):
	## Look
	current_camera().look_input(relative);

func _unhandled_input(event):
	# Focus/Unfocus input
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Other
	if event is InputEventKey:
		process_key_input(event);
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			process_mouse_input(event.relative);
