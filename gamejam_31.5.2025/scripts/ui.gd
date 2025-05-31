extends Control

@export var Blink_Node : Control = null;

@onready var blink_start_pos_y = Blink_Node.position.y;

func blink(seconds):
	var delta : float = 0;
	while delta < 1024:
		delta += get_process_delta_time() / seconds;
		Blink_Node.position.y = blink_start_pos_y + delta;
		await get_tree().process_frame
	Blink_Node.position.y = blink_start_pos_y + delta;
	while delta > 0:
		delta += get_process_delta_time() / seconds;
		Blink_Node.position.y = blink_start_pos_y;
		await get_tree().process_frame

func _ready():
	# Reset blink
	#Blink_Node.position.y = -1024; #blink_start_pos_y = -1024;
	blink();
