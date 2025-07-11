extends Node3D

@onready var password_popup: Popup = $PasswordPopup

@export var password = "179"
@export var printed_object: PackedScene

var player_inside = false
var printed
var printing_finished = false

@export var limited_retries = -1;
var retries_left;
@export var time_before_retry = 2;
@export var progression_warning = true;
var cooldown = 0;


func _ready():
	password_popup.initiate(self)
	retries_left = limited_retries;

func _on_interact_area_body_entered(body: Node3D) -> void:
	player_inside = true

func _on_interact_area_body_exited(body: Node3D) -> void:
	player_inside = false

func _process(delta):
	if (cooldown > 0):
		cooldown -= delta;
	else:
		if Input.is_action_just_pressed("ui_accept"):
			if !player_inside: return
			
			if (limited_retries > 0 and retries_left < 1): return;
			
			if (progression_warning and not %"Player".has_rgb[0]):
				%"UIConsole".show_text_anim("That is a surprise that we will reveal later!<pause:1> Shhhhhh!<pause:3>", false, true, true);
				return;
			if printing_finished:
				if printed:
					printed.visible = false
			else:
				password_popup.interaction_attempt()
				
func text_submitted(text):
	if text == password:
		printed = printed_object.instantiate()
		printed.position.y += 0.5
		add_child(printed)
		(printed as RigidBody3D).freeze = true;
		var print_mat = load("res://materials/printing_mat.tres");
		var mesh_node = printed.get_child(0);
		mesh_node.material_override = print_mat;
		var limit : float = 1.3;
		while (limit > -0.2):
			var delta = get_process_delta_time();
			limit -= delta / 2;
			(mesh_node.get_active_material(0) as ShaderMaterial).set_shader_parameter("limit", limit);
			await get_tree().process_frame;
		mesh_node.material_override = null;
		printing_finished = true
		(printed as RigidBody3D).freeze = false;
		(printed as RigidBody3D).apply_impulse(Vector3(-self.global_basis.z.x * 2, 2, -self.global_basis.z.z * 2));
	else:
		cooldown = time_before_retry;
		if (limited_retries > 0):
			retries_left -= 1;
			if (retries_left == 0):
				%"UIConsole".show_text_anim("[color=#ffffff]Whoops! You messed it up and now the printer is [/color][color=#ff0000]LOCKED[/color][color=#ffffff]! <pause:3>Better luck next time!<pause:10>", false, true, true);
			else:
				%"UIConsole".show_text_anim("[color=#ffffff]Wrong! <pause:1>Watch out, you have [/color][color=#0000ff]" + str(retries_left) + "[/color][color=#ffffff] more tries!<pause:10>", false, true, true);
