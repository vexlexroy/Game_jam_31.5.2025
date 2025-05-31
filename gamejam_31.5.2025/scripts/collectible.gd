extends Node3D

@export var level : int = 0;

func _on_area_3d_body_entered(body):
	if (body == %"Player"):  # if player
		%"Player".pick_up_evolution(level);
		self.queue_free();
	pass
