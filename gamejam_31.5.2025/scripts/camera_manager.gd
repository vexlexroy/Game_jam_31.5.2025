extends Node

@export var player_cameras : Array[PlayerCamera];
@export var enabled_cameras : Array[bool];
var cur_cam_ind : int = 0;
func current_camera() -> PlayerCamera: return player_cameras[cur_cam_ind];

func switch_camera(target_ind):
	if (enabled_cameras[target_ind]):
		#if (cur_cam_ind != target_ind):
			#current_camera().reset_rotation();
		cur_cam_ind = target_ind;
		(player_cameras[target_ind] as Camera3D).make_current();
		%"InputHandler".controlling_drone = target_ind == 1;
		if (target_ind == 1):
			%"Drone/AudioListener3D".make_current();
		else:
			%"Player/Eyes/Head/AudioListener3D".make_current();
		%"CanvasLayer2".get_child(0).visible = target_ind != 1;
		#%"CanvasLayer2".get_child(1).visible = target_ind == 1;
	
