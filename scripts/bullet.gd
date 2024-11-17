extends Node2D

var flipped = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.flip_h = flipped


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir = -1 if flipped else 1
	position.x += 500 * dir * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.name.contains("Enemy")):
		area.damage(3)
		queue_free()
	pass # Replace with function body.

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
