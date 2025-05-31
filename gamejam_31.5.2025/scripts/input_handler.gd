extends Node

var control_active := false;
var controlling_drone := true;

func _input(event):
	# Focus/Unfocus input
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if (control_active):	
		# Other
		if event is InputEventKey:
			process_key_input(event);
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				process_mouse_input(event.relative);

func process_key_input(event):
	if not event.pressed:
		match event.physical_keycode:
			KEY_1: %"CameraManager".switch_camera(0);
			KEY_2: %"CameraManager".switch_camera(1);
			KEY_3: %"CameraManager".switch_camera(2);
			#KEY_4: %"Player".switch_camera(3);
			#KEY_5: %"Player".switch_camera(4);
		#if (index != active_cam_index):
			#get_viewport().get_camera() RESET ROTATION

func process_mouse_input(relative):
	## Look
	%"CameraManager".current_camera().look_input(relative);


func enable_control(value : bool):
	control_active = value;
	%"Player".reset_velocity();
	%"Drone".reset_velocity();
