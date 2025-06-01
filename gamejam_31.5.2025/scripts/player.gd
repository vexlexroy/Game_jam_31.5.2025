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


@onready var BottomWheel = $Mesh/Parent/Bottom
var wheel_rotation_speed = 4.0  # tweak this for visual speed

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
	if (can_move and %"InputHandler".control_active):
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
	# Audio
	if (cur_velocity.length_squared() > 0.5):
		if (not $"TireAudio".playing): $"TireAudio".play(0);
	else:
		if ($"TireAudio".playing): $"TireAudio".stop();
func reset_velocity():
	cur_velocity = Vector3.ZERO; velocity = Vector3.ZERO;

func _physics_process(delta):
	process_movement(delta);
	
	var forward_dir = -global_transform.basis.z.normalized()
	var move_dir = cur_velocity.normalized()
	var dot = forward_dir.dot(move_dir)  # Positive = forward, negative = back
	var input_move_dir := Input.get_vector("Movement_Left", "Movement_Right", "Movement_Forward", "Movement_Backward")
	var move_speed = cur_velocity.length()
	if input_move_dir.y != 0 and move_speed > 0.01:
		var rotation_amount = input_move_dir.y * move_speed * wheel_rotation_speed * delta
		BottomWheel.rotate_z(rotation_amount)
	if input_move_dir.x != 0 and move_speed > 0.01:
		var rotation_amount = input_move_dir.x * move_speed * wheel_rotation_speed * delta
		BottomWheel.rotate_x(rotation_amount)

func _process(delta):
	## Constantly rotate mesh based on look
	$"Mesh".rotation.y = %"CameraManager".current_camera().rotation_parent.rotation.y;
	
	

### Other
func pick_up_evolution(level : int):
	match (level):
		1:  # fpv eye
			%"InputHandler".enable_control(false);
			await %"UI".close_anim(0.4);
			$"PrintAudio".play(0);  # Play sound
			# Log show
			var log = %"TextLoader".load_text("res://text/fpv_acq.txt"); 
			await %"UIConsole".show_text_anim(log, false, false);
			$"PrintAudio".stop();  # Stop sound
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
		2: # arms
			%"InputHandler".enable_control(false);
			#await %"UI".close_anim(0.4);
			look_down();
			# Log show
			var log = %"TextLoader".load_text("res://text/arms_acq.txt"); 
			await %"UIConsole".show_text_anim(log, false, false, false);
			%"UIConsole".show_text_anim("[A.P.] Registered data for effector, printing<dots:3> ", false, false);
			# Visual arm printing
			$"PrintAudio".play(0);  # Play sound
			var print_mat = load("res://materials/printing_mat.tres");
			var right_arm : MeshInstance3D = Visuals.find_child("RightArm");
			var left_arm : MeshInstance3D = Visuals.find_child("LeftArm");
			right_arm.material_override = print_mat;
			left_arm.material_override = print_mat;
			right_arm.visible = true;
			left_arm.visible = true;
			# Print arms
			var limit : float = 1.8;
			while (limit > -0.2):
				var delta = get_process_delta_time();
				limit -= delta / 2;
				(right_arm.get_active_material(0) as ShaderMaterial).set_shader_parameter("limit", limit);
				(left_arm.get_active_material(0) as ShaderMaterial).set_shader_parameter("limit", limit);
				await get_tree().process_frame;
			right_arm.material_override = null;
			left_arm.material_override = null;
			$"PrintAudio".stop();  # Stop sound
			has_arms = true;
			await %"UI".open_anim(0.4);
			%"InputHandler".enable_control(true);
			# Log clear
			await get_tree().create_timer(2).timeout
			#%"UIConsole".reset_text(false, true);
			log = %"TextLoader".load_text("res://text/arms_comms.txt"); 
			%"UIConsole".show_text_anim(log, false, false);
		3: # red eye
			pass
		4: # green eye
			pass
		5: # blue eye
			pass

func look_down():
	%"CameraManager".switch_camera(0);
	var target_angle_x = -45;
	var cur_angle_x = $Eyes/Head/FirstPersonPerspective.rotation_degrees.x;
	while cur_angle_x != target_angle_x:
		if (abs(target_angle_x - cur_angle_x) < 1): return;
		$Eyes/Head/FirstPersonPerspective.rotation_degrees = lerp($Eyes/Head/FirstPersonPerspective.rotation_degrees, Vector3(target_angle_x, 0, 0), 0.2);
		cur_angle_x = $Eyes/Head/FirstPersonPerspective.rotation_degrees.x;
		await get_tree().process_frame;
	return;
