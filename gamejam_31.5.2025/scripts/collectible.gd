extends Node3D

@export var level : int = 0;

func _on_area_3d_body_entered(body):
	var player = get_tree().current_scene.get_node("Player");
	if (body == player):  # if player
		player.pick_up_evolution(level);
		self.queue_free();
	pass
