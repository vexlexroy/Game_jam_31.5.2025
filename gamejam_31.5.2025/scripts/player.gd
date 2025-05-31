extends CharacterBody3D

@export var speed = 5
@export var can_jump : bool = false;
@export var jumpStrength = 5;

@export var player_cameras : Array[PlayerCamera];
@export var enabled_cameras : Array[bool];
var cur_cam_ind : int = 0;
func current_camera() -> PlayerCamera: return player_cameras[cur_cam_ind];

### General
func switch_camera(target_ind):
	if (enabled_cameras[target_ind]):
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

### _ready
func _ready():
	for i in range(len(enabled_cameras)):
		if (enabled_cameras[i]): 
			switch_camera(i); break;



### Other
func pick_up_evolution(level : int):
	match (level):
		1:  # fpv eye
			%"InputHandler".control_active = false;
			await %"UI".close_anim(0.4);
			enabled_cameras[0] = true;
			switch_camera(0);
			await get_tree().create_timer(1.0).timeout
			await %"UI".open_anim(0.4);
			%"InputHandler".control_active = true;
