extends CharacterBody2D


var SPEED = 50.0
var gravity = 600
var direction = -1
var player_chase = false
var player = null
var health = 2
var noise = randf_range(0, 1)

func _physics_process(delta):
	if player_chase:
		if player.global_position.x < global_position.x:
			direction = -1
		else:
			direction = 1

	if health == 0:
		queue_free()

	if player_chase:
		position += (player.position - position) / SPEED

	if noise == 0:
		$"WE'RE_Drones1".pitch_scale = randf_range(0.7, 1.2)
		$"WE'RE_Drones1".playing = true
	if noise == 1:
		$"WE'RE_Drones2".pitch_scale = randf_range(0.7, 1.2)
		$"WE'RE_Drones2".playing = true
	move_and_slide()

func _death(area):
	if area.has_meta("bullet"):
		health -= 1
	if area.has_meta("enemykiller"):
		health = 0

func _on_detection_body_entered(body):
	if body.name == ("Player"):
		player = body
		player_chase = true
		position += direction * ((player.position - position) / lerp(velocity.x, direction * SPEED, 0.2))


func _on_detection_body_exited(body):
	if body.name == ("Player"):
		player = null
		player_chase = false
