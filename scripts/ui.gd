extends Control

var player = null
var health_label = null

func _ready():
	player = get_node("/root/Main/Player/CharacterBody2D")
	health_label = $HealthLabel

func _process(delta):
	update_health_label(player.health)

func update_health_label(health):
	health_label.text = "Health: " + str(health)
