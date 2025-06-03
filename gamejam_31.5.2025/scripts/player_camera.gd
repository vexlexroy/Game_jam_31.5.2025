extends Camera3D
class_name PlayerCamera

### Type: 0 - fpv, 1 - tpv, 2 - top down
@export var type = 0;
@export var rotation_parent : Node3D = null;

@export var rotate_vertical = true;
@export var can_look := true;

## Get transform on start
@onready var start_rotation = self.rotation;
@onready var parent_start_rotation = rotation_parent.rotation if rotation_parent != null else null;
@export var mouse_sensitivity = 0.0025

func reset_rotation():
	if (rotation_parent != null):
		rotation_parent.rotation = parent_start_rotation;
	self.rotation = start_rotation;
	pass

func look_input(relative):
	if (can_look):
		match (type):
			0: # First person
				# Vertical
				if (rotate_vertical):
					self.rotate_x(-relative.y * mouse_sensitivity);
					self.rotation.x = clamp(self.rotation.x, deg_to_rad(-80), deg_to_rad(80))
				# Horizontal
				rotation_parent.rotate_y(-relative.x * mouse_sensitivity);
			1: # Third person
				# Vertical
				if (rotate_vertical):
					$"..".rotate_x(relative.y * mouse_sensitivity);
					$"..".rotation.x = clamp($"..".rotation.x, deg_to_rad(-20), deg_to_rad(20))
				# Horizontal
				rotation_parent.rotate_y(-relative.x * mouse_sensitivity);
				#rotation_parent.global_rotate(Vector3.RIGHT, -relative.y * mouse_sensitivity);
				#rotation_parent.global_rotate(Vector3.UP, -relative.x * mouse_sensitivity);
			2: # Top down
				rotation_parent.rotate_y(-relative.x * mouse_sensitivity);
				pass

func get_forward():
	match (type):
		0, 1: return rotation_parent.get_global_transform_interpolated().basis.z;
		2: 
			return rotation_parent.get_global_transform_interpolated().basis.z; #-self.get_global_transform_interpolated().basis.y;
	return null;
func get_right():
	match (type):
		0, 1: return rotation_parent.get_global_transform_interpolated().basis.x;
		2: 
			return rotation_parent.get_global_transform_interpolated().basis.x; #self.get_global_transform_interpolated().basis.x;
	return null;
