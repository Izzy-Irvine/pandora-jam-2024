extends Node2D

var flipped = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.flip_h = flipped


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir = -1 if flipped else 1
	position.x += 100 * dir * delta
