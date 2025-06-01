extends Node3D

@onready var password_popup: Popup = $PasswordPopup

@export var password = "179"
@export var printed_object: PackedScene

var player_inside = false

func _ready():
	password_popup.initiate(self)

func _on_interact_area_body_entered(body: Node3D) -> void:
	player_inside = true

func _on_interact_area_body_exited(body: Node3D) -> void:
	player_inside = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !player_inside: return
		password_popup.interaction_attempt()
				
func text_submitted(text):
	if text == password:
		print("Correct")
		var printed = printed_object.instantiate()
		printed.position.y += 0.6
		add_child(printed)
	else:
		print("Incorrect")
		
