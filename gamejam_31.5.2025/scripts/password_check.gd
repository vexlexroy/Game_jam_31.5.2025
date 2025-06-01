extends Popup

@onready var line_edit: LineEdit = $LineEdit

var interacting = false

var printer

func initiate(printer):
	self.printer = printer
	
var input_handler
func _ready():
	input_handler = get_tree().current_scene.get_node_or_null("InputHandler")

func _on_line_edit_text_submitted(new_text: String) -> void:
	hide()
	line_edit.text = ""
	input_handler.enable_control(true)
	printer.text_submitted(new_text)
	
	
func interaction_attempt():
	if interacting:
		interacting = false
		return
	interacting = true
	input_handler.enable_control(false)
	popup_centered()
	line_edit.grab_focus()
