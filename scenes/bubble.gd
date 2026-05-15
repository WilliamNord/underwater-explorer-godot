extends RigidBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func pop():
	animated_sprite_2d.play("bubble pop")
