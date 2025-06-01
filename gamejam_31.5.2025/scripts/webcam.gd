extends Node2D

func _ready():
	var stream = VideoStreamWebcam.new()
	stream.device = 0  # Use default webcam (or list devices via `VideoStreamWebcam.get_device_list()`)
	
	var video_player = $VideoStreamPlayer
	video_player.stream = stream
	video_player.play()
