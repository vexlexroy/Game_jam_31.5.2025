extends Node

@export var skip_intro = true;

### On start
func _ready():
	if (not skip_intro):
		# Console text
		%"UI".close_instant();
		for o in %"TextLoader".opening_sequence:
			var content = %"TextLoader".load_text(o);
			await %"UIConsole".show_text_anim(content, true);
	# Open eyes
	await %"UI".open_anim(0.4);
	%"InputHandler".control_active = true;
	return
