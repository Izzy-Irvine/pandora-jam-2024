extends Node2D

var flipped = false
var enemies_in_area = []
var damage_timer = 0.0
const DAMAGE_INTERVAL = 0.0912

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if flipped:
		$AnimatedSprite2D.scale *= Vector2(-1, -1)
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir = -1 if flipped else 1
	position.x += 100 * dir * delta

	damage_timer += delta
	if damage_timer >= DAMAGE_INTERVAL:
		damage_timer = 0.0
		for enemy in enemies_in_area:
			enemy.damage(1)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name.contains("Enemy"):
		enemies_in_area.append(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area in enemies_in_area:
		enemies_in_area.erase(area)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
