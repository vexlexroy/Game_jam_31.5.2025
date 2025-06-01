extends Node

var control_active := false;
var controlling_drone := true;

func _input(event):
	# Focus/Unfocus input
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if ($"..".intro_ongoing):
		if event is InputEventKey:
			if event.keycode == KEY_ESCAPE:
				$"..".stop_ongoing_intro();
	elif (control_active):	
		# Other
		if event is InputEventKey:
			process_key_input(event);
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				process_mouse_input(event.relative);

func process_key_input(event):
	if not event.pressed:
		match event.physical_keycode:
			KEY_1: %"CameraManager".switch_camera(0); secret_countdown = 0;
			KEY_2: %"CameraManager".switch_camera(1); secret_countdown = 0;
			KEY_6: %"CameraManager".switch_camera(2); secret_countdown = 0;
			KEY_4:
				if (secret_countdown > 0 and secret_input == "7"):
					secret_input = "74";
			KEY_7:
				if (secret_countdown > 0 and secret_input == ""):
					secret_input = "7";
			KEY_SPACE: return;
			_:
				secret_countdown = 0;
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




var secret_countdown = 0;
var secret_input = "";

func _process(delta):
	if (secret_countdown > 0 and len(secret_input) < 3):
		secret_countdown -= delta;
		if (secret_input == "74"):
			secret_countdown = 0;
			%"UIConsole".show_text_anim("[color=#ffffff]Great job! You found the [/color][color=#ff0000]S[/color][color=#00ff00]e[/color][color=#0000ff]C[/color][color=#ff0000]r[/color][color=#00ff00]E[/color][color=#0000ff]t[/color][color=#ffffff]!![/color]", false, false, true);
	else:
		secret_countdown = 0; secret_input = "";
