extends Area2D

var collected = false

@onready var global = get_node("/root/Global")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func __collect(area):
	if area.has_meta("Player") and not collected:
		$AnimatedSprite2D.play("Collected")
		collected = true
		global.coining += 1
