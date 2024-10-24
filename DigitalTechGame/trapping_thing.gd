extends Path2D

var trap = false
var ldrop = false
@export var last = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Dropping
	if trap and not last:
		if $PathFollow2D.progress_ratio < 0.95:
			$PathFollow2D.progress_ratio += 0.04
	elif ldrop and last:
		await get_tree().create_timer(2.5).timeout
		if $PathFollow2D.progress_ratio < 0.95:
			$PathFollow2D.progress_ratio += 0.015

# Detecting player
func _on_droppingwall_area_entered(area):
	if area.has_meta("Player"):
		trap = true
		ldrop = true
