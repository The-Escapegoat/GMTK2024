extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@onready var col = $CollisionShape2D
@export var currentSize : int = 1
var player
var direction : Vector2
@export var launchAmount : int

func _ready():
	anim.play(str(currentSize))
	col.scale = Vector2(currentSize, currentSize)
func Grow():
	$Grow.pitch_scale = randf_range(1.0, 1.4)
	$Grow.play()
	player = get_tree().get_nodes_in_group("Player")[0]
	direction = global_position.direction_to(player.global_position)
	direction.x = roundi(direction.x)
	direction.y = roundi(direction.y)
	direction = direction.normalized()
	if (currentSize < 5):
		currentSize += 1
		anim.play(str(currentSize))
		col.scale = Vector2(currentSize, currentSize)
		await get_tree().create_timer(0.01).timeout
		currentSize += 1
		anim.play(str(currentSize))
		col.scale = Vector2(currentSize, currentSize)

		
func Shrink():
	$Shrink.pitch_scale = randf_range(1.0, 1.4)
	$Shrink.play()
	player = get_tree().get_nodes_in_group("Player")[0]
	direction = global_position.direction_to(player.global_position)
	direction.x = roundi(direction.x)
	direction.y = roundi(direction.y)
	direction = direction.normalized()
	if (currentSize > 1):
		currentSize -= 1
		anim.play(str(currentSize))
		col.scale = Vector2(currentSize, currentSize)
		await get_tree().create_timer(0.01).timeout
		currentSize -= 1
		anim.play(str(currentSize))
		col.scale = Vector2(currentSize, currentSize)
