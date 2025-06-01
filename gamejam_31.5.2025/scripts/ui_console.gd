extends Control

@export var FullScreen : Control;
@export var SideScreen : Control;

var base_delay = 0.01;

class Sequence:
	var text : String;
	var delay : float;

var is_printing = [false, false];
var cancel_current_printing = [false, false];


func _ready():
	FullScreen.visible = false;
	SideScreen.visible = false;

func enable(value : bool):
	self.visible = value;

func reset_text(full : bool, check_printing : bool = false):
	if (not check_printing or not is_printing[1 if full else 0]):
		var screen : Control = FullScreen if full else SideScreen;
		var rtl : RichTextLabel = screen.get_child(1).get_child(0);
		rtl.visible_characters = 0; rtl.text = "";

func append_text_anim(text : String, full : bool = false, delay : float = base_delay, stream : bool = false):
	if (not stream): is_printing[1 if full else 0] = true;
	var screen : Control = FullScreen if full else SideScreen;
	var rtl : RichTextLabel = screen.get_child(1).get_child(0);
	#rtl.text += text;
	screen.visible = true;
	# animate
	var i = 0;
	while i < len(text):  #for i in range(len(text)):
		if (text[i] == '['):
			if (i + 5 < len(text) and text.substr(i, 6) == "[color"):
				rtl.visible_characters += 15;
				rtl.text += text.substr(i, 15);
				i += 14;
			elif (i + 1 < len(text) and text[i + 1] == '/'):
				rtl.visible_characters += 8;
				rtl.text += text.substr(i, 8);
				i += 7;
			else:
				rtl.visible_characters += 1;
				rtl.text += text[i];
		else:
			rtl.visible_characters += 1;
			rtl.text += text[i];
		await get_tree().create_timer(delay).timeout
		if (cancel_current_printing[1 if full else 0]):
			is_printing[1 if full else 0] = false; return;
		i += 1;
	if (not stream): is_printing[1 if full else 0] = false;
	return

func show_text_anim(text : String, full : bool = false, erase_after : bool = false, delay : float = base_delay):
	if (is_printing[1 if full else 0]):
		cancel_current_printing[1 if full else 0] = true;
		await get_tree().process_frame;
		await not cancel_current_printing[1 if full else 0];
		await not is_printing[1 if full else 0];
	is_printing[1 if full else 0] = true;
	reset_text(full);
	var full_seq = decode_text(text, delay);
	for seq in full_seq:
		await append_text_anim(seq.text, full, seq.delay, true);
		if (cancel_current_printing[1 if full else 0]):
			cancel_current_printing[1 if full else 0] = false; return;
	if (erase_after):
		reset_text(full);
		enable(false);
	is_printing[1 if full else 0] = false;
	return

### Markup rules
# 3d -> 3 dots								: [duration]|1
# dots -> dots for a duration 				: [duration]|1
func decode_markup(markup : String, params : String = "") -> Sequence:
	#print("Decode received '" + str(markup) + "' | '" + str(params) + "'");
	var seq = Sequence.new();
	match (markup):
		"3d":
			seq.text = "...";
			if (params != ""): seq.delay = float(params) / 3;
			else: seq.delay = 1.5;
		"dots":
			seq.delay = 0.5;
			seq.text = ".".repeat(round(float(params) / 0.5));
		"pause":
			seq.text = " ";
			if (params != ""): seq.delay = float(params);
			else: seq.delay = 2;
	return seq;
func decode_text(text : String, base_delay : float = base_delay):
	var sequences : Array[Sequence] = [];
	var cur_text = "";
	var i = 0;
	while i < len(text):
		var t = text[i];
		if (t == '<'):
			#print("Found markup...");
			var seq = Sequence.new();
			seq.text = cur_text; seq.delay = base_delay;
			sequences.append(seq);
			cur_text = ""; var params = "";
			i += 1;
			while (i < len(text) and text[i] != '>'):
				if (text[i] == ':'):
					i += 1; params = text[i];
				else:
					if (params == ""):
						cur_text += text[i]; #print("Adding to markup name: " + str(text[i]));
					else: 
						params += text[i]; #print("Adding to params: " + str(text[i]));
				i += 1;
			sequences.append(decode_markup(cur_text, params));
			cur_text = "";
		else:
			cur_text += t;
			#print("Adding " + str(t));
		i += 1;
	var seq = Sequence.new();
	seq.text = cur_text; seq.delay = base_delay;
	sequences.append(seq);
	return sequences;
