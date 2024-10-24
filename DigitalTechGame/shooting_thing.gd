extends Area2D

var direction
var SPEED = 1000.0

func _process(delta):
	# Movement
	position.x += SPEED * delta * -direction

# Stopping on platforms
func _on_area_entered(area):
	if area.has_meta("platform"):
		queue_free()
