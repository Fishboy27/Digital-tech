extends PathFollow2D

var trap = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trap:
		if progress_ratio < 0.98:
			progress_ratio = progress_ratio + 0.0038




func _boulder(area):
	if area.has_meta("Player"):
		trap = true
