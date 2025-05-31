extends CharacterBody3D

@export var acceleration : float = 4;
@export var deceleration : float = 3;
@export var max_speed : float = 5;

var cur_velocity := Vector3.ZERO;

var rotate_follow_speed := 0.2;

func _physics_process(delta):
	### Movement
	# Move with arrow keys
	"""
	var input_move_dir := Input.get_vector("Drone_Left", "Drone_Right", "Drone_Forward", "Drone_Backward")
	var direction : Vector3 = (%"CameraManager".current_camera().get_forward() * input_move_dir.y) + (%"CameraManager".current_camera().get_right() * input_move_dir.x)
	if (direction != Vector3.ZERO):
		cur_velocity += direction * acceleration * delta;
		if (cur_velocity.length() > max_speed):
			cur_velocity = cur_velocity * (max_speed / cur_velocity.length());
	else:
		cur_velocity = cur_velocity.lerp(Vector3.ZERO, deceleration * delta);
	velocity = cur_velocity;
	move_and_slide();
	"""
	# Follow bot
	if (Vector2(self.position.x, self.position.z) != Vector2(%"Player".position.x, %"Player".position.z)):
		var direction : Vector3 = Vector3(%"Player".position.x - self.position.x, 0, %"Player".position.z - self.position.z);
		if (direction != Vector3.ZERO and direction.length() > 1):
			cur_velocity += direction.normalized() * acceleration * delta;
			if (cur_velocity.length() > max_speed):
				cur_velocity = cur_velocity * (max_speed / cur_velocity.length());
		else:
			cur_velocity = cur_velocity.lerp(Vector3.ZERO, deceleration * delta);
		velocity = cur_velocity;
		move_and_slide();
	## Rotate camera towards where player bot is looking
	print($TopDownHead/TopDownOrthogonal.rotation.y)
	print(%"CameraManager".current_camera().rotation_parent.rotation.y)
	if ($TopDownHead/TopDownOrthogonal.rotation.y != \
		%"CameraManager".current_camera().rotation_parent.rotation.y):
			$TopDownHead/TopDownOrthogonal.rotation.y += (%"CameraManager".current_camera().rotation_parent.rotation.y - $TopDownHead/TopDownOrthogonal.rotation.y) * (rotate_follow_speed);
		#$TopDownHead/TopDownOrthogonal.rotation.y = \
			#lerp($TopDownHead/TopDownOrthogonal.rotation.y, %"CameraManager".current_camera().rotation_parent.rotation.y, rotate_follow_speed);
	print($TopDownHead/TopDownOrthogonal.rotation.y);

func reset_velocity():
	cur_velocity = Vector3.ZERO; velocity = Vector3.ZERO;
