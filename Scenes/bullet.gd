extends CharacterBody2D

var direction : Vector2
@export var speed : int

func launch(dir):
	direction = dir
	$AnimatedSprite2D.play("shooting")

func _physics_process(delta):
	velocity = direction * speed * delta
	move_and_slide()
