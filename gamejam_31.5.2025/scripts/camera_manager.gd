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
		%"InputHandler".controlling_drone = target_ind == 2;
