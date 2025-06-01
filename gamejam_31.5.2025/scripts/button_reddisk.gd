extends Node3D


func _on_area_3d_body_entered(body):
	if (body == %"Drone"):
		%"Test".spawn_red_disk();
