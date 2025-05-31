extends CharacterBody3D

@export var can_move := true;
@export var acceleration : float = 16;
@export var deceleration : float = 10;
@export var max_speed : float = 4.5;
var cur_velocity := Vector3.ZERO;

@export var can_jump : bool = false;
@export var jumpStrength = 5;

### Parts
@onready var Visuals = $Mesh/Parent;
@export var has_arms = false;
@export var has_fpv = false;
@export var has_rgb = [false, false, false];

func _ready():
	# FPV
	#%"CameraManager".enabled_cameras[0] = has_fpv;
	# Arms
	Visuals.find_child("RightArm").visible = has_arms;
	Visuals.find_child("LeftArm").visible = has_arms;
	# RGB
	return

### _physics_process
func process_movement(delta):
	# GRAVITY
	var gravity_vel = Vector3.ZERO;
	if not is_on_floor():
		gravity_vel += get_gravity() * delta
	var decelerate := true;
	if (can_move):
		if is_on_floor():
			if can_jump and Input.is_action_just_pressed("Movement_Jump"):
					gravity_vel -= get_gravity().normalized() * jumpStrength
			else:
				var input_move_dir := Input.get_vector("Movement_Left", "Movement_Right", "Movement_Forward", "Movement_Backward")
				var direction : Vector3 = (%"CameraManager".current_camera().get_forward() * input_move_dir.y) + (%"CameraManager".current_camera().get_right() * input_move_dir.x)
				if (direction != Vector3.ZERO):
					cur_velocity += direction * acceleration * delta;
					if (cur_velocity.length() > max_speed):
						cur_velocity = cur_velocity * (max_speed / cur_velocity.length());
					decelerate = false;
	if (decelerate):
		cur_velocity = cur_velocity.lerp(Vector3.ZERO, deceleration * delta);
	velocity = cur_velocity + gravity_vel;
	#print(velocity.length());
	#var pre_slide_vel = velocity;
	move_and_slide()
func reset_velocity():
	cur_velocity = Vector3.ZERO; velocity = Vector3.ZERO;

func _physics_process(delta):
	process_movement(delta);

func _process(delta):
	## Constantly rotate mesh based on look
	$"Mesh".rotation.y = %"CameraManager".current_camera().rotation_parent.rotation.y;

### Other
func pick_up_evolution(level : int):
	match (level):
		1:  # fpv eye
			%"InputHandler".enable_control(false);
			await %"UI".close_anim(0.4);
			# Log show
			var log = %"TextLoader".load_text("res://text/fpv_acq.txt"); 
			await %"UIConsole".show_text_anim(log, false, false);
			%"CameraManager".enabled_cameras[0] = true;
			%"CameraManager".switch_camera(0);
			has_fpv = true;
			await %"UI".open_anim(0.4);
			%"InputHandler".enable_control(true);
			# Log clear
			await get_tree().create_timer(2).timeout
			#%"UIConsole".reset_text(false, true);
			log = %"TextLoader".load_text("res://text/fpv_comms.txt"); 
			%"UIConsole".show_text_anim(log, false, false);
		2: # red eye
			pass
