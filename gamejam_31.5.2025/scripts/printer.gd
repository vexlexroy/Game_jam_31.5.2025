extends Node3D

@onready var password_popup: Popup = $PasswordPopup

@export var password = "179"
@export var printed_object: PackedScene

var player_inside = false
var printed
var printing_finished = false

func _ready():
	password_popup.initiate(self)

func _on_interact_area_body_entered(body: Node3D) -> void:
	player_inside = true

func _on_interact_area_body_exited(body: Node3D) -> void:
	player_inside = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !player_inside: return
		
		if printing_finished:
			print("Upgrade!!")
			if printed:
				printed.visible = false
		else:
			password_popup.interaction_attempt()
				
func text_submitted(text):
	if text == password:
		print("Correct")
		printed = printed_object.instantiate()
		printed.position.y += 0.5
		add_child(printed)
		var print_mat = load("res://materials/printing_mat.tres");
		printed.material_override = print_mat;
		var limit : float = 1.3;
		while (limit > -0.2):
			var delta = get_process_delta_time();
			limit -= delta / 2;
			(printed.get_active_material(0) as ShaderMaterial).set_shader_parameter("limit", limit);
			await get_tree().process_frame;
		printed.material_override = null;
		printing_finished = true
				
	else:
		print("Incorrect")
		
