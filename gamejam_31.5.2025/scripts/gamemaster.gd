extends Node

@export var skip_intro = true;
@export var skip_instructions = false;

### On start
func _ready():
	# Spawn FPV Disk
	spawn_fpv_disk();
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
	# Start game -> start soundtrack
	%"Player/SoundtrackAudio".play(0);
	# Instructions
	if (not skip_instructions):
		await get_tree().create_timer(2).timeout
		for o in %"TextLoader".opening_sequence_instructions:
			var content = %"TextLoader".load_text(o);
			await %"UIConsole".show_text_anim(content, false, true);
	return

func spawn_fpv_disk():
	var choices = $Collectibles/FPVDisk_Spawns.get_children();
	var spawn = choices.pick_random();
	var disk = load("res://scenes/disk.tscn");
	var instance = disk.instantiate()
	instance.name = "FPVDisk"; instance.level = 1;
	$Collectibles.add_child(instance)
	instance.global_position = spawn.global_position;
	return
