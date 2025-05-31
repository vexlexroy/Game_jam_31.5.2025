extends Node

@export var skip_intro = true;
@export var skip_instructions = false;

### On start
func _ready():
	for i in range(len(%"CameraManager".enabled_cameras)):
		if (%"CameraManager".enabled_cameras[i]): 
			%"CameraManager".switch_camera(i); break;
	# Intro
	if (not skip_intro):
		# Console text
		%"UI".close_instant();
		for o in %"TextLoader".opening_sequence:
			var content = %"TextLoader".load_text(o);
			await %"UIConsole".show_text_anim(content, true, true);
	# Open eyes
	await %"UI".open_anim(0.4);
	%"InputHandler".control_active = true;
	# Instructions
	if (not skip_instructions):
		await get_tree().create_timer(2).timeout
		for o in %"TextLoader".opening_sequence_instructions:
			var content = %"TextLoader".load_text(o);
			await %"UIConsole".show_text_anim(content, false, true);
	return
