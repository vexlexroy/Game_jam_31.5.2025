extends Node
#["res://text/opening_console_text0.txt", 
#"res://text/opening_console_text1.txt"
var opening_sequence = ["res://text/opening_console_text0.txt", 
						"res://text/opening_console_text1.txt",
						"res://text/opening_console_text2.txt"];

var opening_sequence_instructions = ["res://text/opening_console_inst0.txt"];

func load_text(path : String):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content
