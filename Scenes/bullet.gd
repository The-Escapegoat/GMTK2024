extends CharacterBody2D

var direction : Vector2
@export var speed : int
var grow : bool

func launch(dir, a  = true):
	direction = dir
	grow = a
	if(a == true):
		$AnimatedSprite2D.play("grow")
	else:
		$AnimatedSprite2D.play("shrink")

func _physics_process(delta):
	velocity = direction * speed * delta
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("resizable")):
		if(grow):
			body.Grow()
		if(!grow):
			body.Shrink()
	self.queue_free()
