extends CharacterBody2D

var speed = 500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	# Movement
	velocity.x = lerp(velocity.x, direction * speed, 0.2)
