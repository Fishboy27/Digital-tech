#extends ColorRect
#
#var betweeen = true
#var between = false
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
#func _on_inbetween_timeout():
	#position.x -= 883
	#await get_tree().create_timer(0.5).timeout
	#position.x += 883
	#await get_tree().create_timer(1.2).timeout
	#$"../inbetween".start()
