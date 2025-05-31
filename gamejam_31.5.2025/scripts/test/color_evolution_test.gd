extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect
var shader_material;

var stage = 0;
var blurred = true
var unblurred = false
var unblurring_stage = 0

func _ready():
	shader_material = color_rect.material as ShaderMaterial

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("Upgrade...")
		stage += 1
		if stage == 4:
			stage = 0
		shader_material.set_shader_parameter("stage", stage)
	if Input.is_action_just_pressed("ui_right"):
		print("Unblur...")
		blurred = false
	if not blurred and not unblurred:
		if unblurring_stage < 0.8:
			unblurring_stage += 1 * delta
			var size = lerp(Vector2(32, 28), Vector2(0, 0), unblurring_stage)
			shader_material.set_shader_parameter("size", size)
		else:
			unblurring_stage = 1
			var size = lerp(Vector2(32, 28), Vector2(0, 0), 0.8)
			shader_material.set_shader_parameter("size", size)
			unblurred = true
