extends CharacterBody2D


const SPEED = 300.0

func _ready():
	if get_node("player").global_position.x < global_position.x:


