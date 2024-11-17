extends Node2D

var flipped = false
var lifetime = 0.0
@export var max_damage = 3
@export var min_damage = 0.1
@export var expected_lifetimme = 0.33 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.flip_h = flipped

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime += delta
	var dir = -1 if flipped else 1
	position.x += 500 * dir * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name.contains("Enemy"):
		var damage = max_damage - ((max_damage - min_damage) * (lifetime / expected_lifetimme))
		damage = clamp(damage, min_damage, max_damage)
		area.damage(damage)
		print("Dealt " + str(damage) + " damage to " + area.name)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
