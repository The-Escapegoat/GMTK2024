extends Node2D

@export var current_room : Room
@export var rooms : Array
@onready var bg = $ParallaxBackground

var time : float = 0.0
var msec : int = 0
var sec : int = 0
var min  : int = 0
var has_won : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!has_won):
		time += delta
