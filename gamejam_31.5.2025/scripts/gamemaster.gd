extends Node

@export var skip_intro = true;
@export var skip_instructions = true;

var intro_ongoing = false;
var stop_intro = false;

var spawn = null;

### On start
func _ready():
	# Spawn FPV Disk
	spawn_fpv_disk();
	spawn_red_disk()
	for i in range(len(%"CameraManager".enabled_cameras)):
		if (%"CameraManager".enabled_cameras[i]): 
			%"CameraManager".switch_camera(i); break;
	# Drone disable collisions and clear go to
	(%"Drone".get_node("CollisionShape3D") as CollisionShape3D).disabled = true;
	%"Drone".go_to_point_behaviour = false;
	# Intro
	if (not skip_intro):
		intro_ongoing = true;
		# Console text
		%"UI".close_instant();
		for o in %"TextLoader".opening_sequence:
			var content = %"TextLoader".load_text(o);
			await %"UIConsole".show_text_anim(content, true, true);
			if (stop_intro): 
				%"UIConsole".reset_text(true); %"UIConsole".enable(false); break;
		intro_ongoing = false;
	# Open eyes
	await %"UI".open_anim(0.4);
	%"UI".open_instant();
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

func stop_ongoing_intro():
	stop_intro = true;
	%"UIConsole".cancel_current_printing[1] = true;

func spawn_fpv_disk():
	# Choose variation
	var choices = $Collectibles/SpawnVariations.get_children();
	spawn = choices.pick_random();
	for i in range(len(choices)):
		if choices[i] != spawn:
			choices[i].queue_free();
	# Load fpv disk
	var disk = load("res://scenes/disk.tscn");
	var instance = disk.instantiate()
	instance.name = "FPVDisk"; instance.level = 1;
	$Collectibles.add_child(instance)
	instance.global_position = spawn.global_position;
	return
func spawn_arms_disk():
	# Disable point2 collider
	spawn.get_node("Point2").get_node("Block").queue_free();
	# Load arms disk
	var disk = load("res://scenes/disk.tscn");
	var instance = disk.instantiate()
	instance.name = "ArmsDisk"; instance.level = 2;
	$Collectibles.add_child(instance)
	instance.global_position = spawn.get_node("Point2").global_position;
func spawn_red_disk():
	# Load red disk
	var disk = load("res://scenes/disk.tscn");
	var instance : RigidBody3D = disk.instantiate()
	instance.name = "RedDisk"; instance.level = 3;
	$Collectibles.add_child(instance)
	instance.global_position = $Environnment/DroneMaze/RedDiskSpawnPoint.global_position;
	instance.apply_impulse(Vector3(-2, 2, 0));
