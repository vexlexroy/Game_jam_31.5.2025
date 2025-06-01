extends CharacterBody3D

@export var acceleration : float = 6;
@export var deceleration : float = 5;
@export var max_speed : float = 5;

var cur_velocity := Vector3.ZERO;

var rotate_follow_speed := 0.04;
@export var go_to_point_behaviour := false;
@export var go_to_point := Vector3.ZERO;

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
	# Follow bot or go to a position
	var target_pos = Vector3.ZERO;
	if (go_to_point_behaviour):
		target_pos = go_to_point;
	else: 
		target_pos = %"Player".position;
	if (Vector2(self.position.x, self.position.z) != Vector2(target_pos.x, target_pos.z)):
		var direction : Vector3 = Vector3(target_pos.x - self.position.x, 0, target_pos.z - self.position.z);
		if (direction != Vector3.ZERO and direction.length() > cur_velocity.length() / 1.5):
			cur_velocity += direction.normalized() * acceleration * delta;
			if (cur_velocity.length() > max_speed):
				cur_velocity = cur_velocity * (max_speed / cur_velocity.length());
		else:
			cur_velocity = cur_velocity.lerp(Vector3.ZERO, deceleration * delta);
		velocity = cur_velocity;
		move_and_slide();
	## Rotate camera towards where player bot is looking
	if ($TopDownHead/TopDownOrthogonal.rotation.y != \
		%"CameraManager".current_camera().rotation_parent.rotation.y):
		$TopDownHead/TopDownOrthogonal.rotation.y = \
			lerp_angle($TopDownHead/TopDownOrthogonal.rotation.y, %"CameraManager".current_camera().rotation_parent.rotation.y, rotate_follow_speed);

func reset_velocity():
	cur_velocity = Vector3.ZERO; velocity = Vector3.ZERO;
