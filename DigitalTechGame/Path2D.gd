extends Path2D

var drop = false
var ldrop = false
@export var next_drop : Node
@export var first_drop = false
@export var last_drop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drop:
		if $PathFollow2D.progress_ratio < 0.98:
			$PathFollow2D.progress_ratio += 0.009
	if $PathFollow2D.progress_ratio > 0.6 and not last_drop:
		if next_drop != null:
			next_drop._start_drop()
	if ldrop:
		if $PathFollow2D.progress_ratio < 0.98:
			$PathFollow2D.progress_ratio += 0.14

#func _on_timer_timeout():
	#drop = true
#
#
#func _on_droppingwall_area_entered(area):
	#if area.has_meta("Player"):
		#drop = true
		#$"../Timer".start()
		


func _on_area_entered(area):
	if first_drop:
		if area.has_meta("Player"):
			await get_tree().create_timer(0.5).timeout
			_start_drop()

func _start_drop():
	drop = true

func _last_drop():
	ldrop = true
