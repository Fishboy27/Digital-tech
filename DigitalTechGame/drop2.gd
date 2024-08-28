extends PathFollow2D

var drop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drop:
		if progress_ratio < 0.98:
			progress_ratio = progress_ratio + 0.02

func _on_timer_timeout():
	drop = true


func _on_droppingwall_area_entered(area):
	if area.has_meta("Player"):
		drop = true
		$"../Timer".start()
		
