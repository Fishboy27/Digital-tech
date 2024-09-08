extends CharacterBody2D


var SPEED = 50.0
var gravity = 600
var direction = -1.0
var player_chase = false
var player = null
var can_shoot = true
var shootable = false

@onready var global = get_node("/root/Global")
@export var shooting_thing: PackedScene

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if player_chase:
		if player.global_position.x < global_position.x:
			direction = -1.0
			$AnimatedSprite2D.scale.x = -direction
		else:
			direction = 1.0
			$AnimatedSprite2D.scale.x = -direction

	if global.health == 0:
		queue_free()

	if global.health == 1:
		SPEED = 75

#turning
	if $AnimatedSprite2D/RayCast2D.is_colliding() and not player_chase:
		#if $AnimatedSprite2D/RayCast2D.get_collider().has_meta():
		_flip()

	if player_chase:
		position += (player.position - position) / SPEED
	else:
		velocity.x = lerp(velocity.x, direction * SPEED * 7, 0.5)

	if shootable:
		_shoot()

	$"../CanvasLayer/Boss_health/HEALTH".value = global.health
	$"../CanvasLayer/Boss_health/PERCENT".value = global.health

	move_and_slide()


func _flip():
	direction = -direction
	$AnimatedSprite2D.scale.x = -direction

func _death(area):
	if area.has_meta("bullet"):
		global.health -= 1

func _on_detection_body_entered(body):
	if body.name == ("Player"):
		player = body
		player_chase = true
		position += direction * ((player.position - position) / lerp(velocity.x, direction * SPEED, 0.2))


func _on_detection_body_exited(body):
	if body.name == ("Player"):
		player = null
		player_chase = false
		velocity.x = lerp(velocity.x, direction * SPEED * 7, 0.5)

func _shoot():
	if can_shoot:
		var shooting_thing = shooting_thing.instantiate()
		shooting_thing.position = $AnimatedSprite2D/bullet_spawn.global_position
		shooting_thing.direction = $AnimatedSprite2D.scale.x
		add_sibling(shooting_thing)
		can_shoot = false
		await get_tree().create_timer(4).timeout
		can_shoot = true

func _on_shoot_body_entered(body):
	if body.name == ("Player"):
		shootable = true

func _on_shoot_body_exited(body):
	if body.name == ("Player"):
		shootable = false
