extends CharacterBody2D


var SPEED = 5.0
var gravity = 600
var direction = -1
var player_chase = false
var player = null
var health = 1
var noise = randf_range(0, 1)
var ySPEED = 0.02

func _physics_process(delta):
	# Flipping direction
	if player_chase:
		if player.global_position.x < global_position.x:
			direction = -1
		else:
			direction = 1

# Death
	if health == 0:
		queue_free()

# Follows player
	if player_chase:
		position.x = move_toward(position.x, player.position.x, SPEED)
		position.y = lerp(position.y, player.position.y, ySPEED)

	# Sounds
	if noise == 0:
		$"WE'RE_Drones1".pitch_scale = randf_range(0.7, 1.2)
		$"WE'RE_Drones1".playing = true
	if noise == 1:
		$"WE'RE_Drones2".pitch_scale = randf_range(0.7, 1.2)
		$"WE'RE_Drones2".playing = true

	move_and_slide()

# Death
func _death(area):
	if area.has_meta("bullet"):
		health -= 1
	if area.has_meta("enemykiller"):
		health = 0

# Detecting player
func _on_detection_body_entered(body):
	if body.name == ("Player"):
		player = body
		player_chase = true
		position.x = move_toward(position.x, player.position.x, SPEED)
		position.y = move_toward(position.y, player.position.y, SPEED)

# Undetecting player
func _on_detection_body_exited(body):
	if body.name == ("Player"):
		player = null
		player_chase = false
