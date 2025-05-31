extends Node3D

var speed = 1
@onready var timer: Timer = $Timer

func _ready():
	timer.start()
	
func _process(delta):
	position.y += speed * delta
	

func _on_timer_timeout() -> void:
	speed *= -1
	timer.start()
