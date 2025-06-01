extends CanvasLayer

@export var Blink_Node : Control = null;

@onready var blink_start_pos_y = Blink_Node.position.y;

func close_instant():
	Blink_Node.position.y = 0;
func open_instant():
	Blink_Node.position.y = blink_start_pos_y;
func close_anim(seconds):
	var s_height = DisplayServer.screen_get_size()[1];
	var delta : float = 0;
	open_instant();
	while delta < s_height:
		delta += s_height * (get_process_delta_time() / seconds);
		Blink_Node.position.y = blink_start_pos_y + delta;
		await get_tree().process_frame
	close_instant();
func open_anim(seconds):
	var s_height = DisplayServer.screen_get_size()[1];
	var delta : float = s_height;
	close_instant();
	while delta > 0:
		delta -= s_height * (get_process_delta_time() / seconds);
		Blink_Node.position.y = blink_start_pos_y + delta;
		await get_tree().process_frame
	open_instant();
func blink(seconds):
	await close_anim(seconds);
	open_anim(seconds);

func _ready():
	# Reset blink
	Blink_Node.position.y = -1024; blink_start_pos_y = -1024;
