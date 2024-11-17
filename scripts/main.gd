extends Node2D

var player = null
var level = null

func _ready():
	player = $Player/CharacterBody2D
	player.connect("scroll_right", Callable(self, "_on_player_scroll_right"))
	level = $Level

func _on_player_scroll_right(screen_amount):
	print("Scrolling right", screen_amount)	
	level.position.x -= screen_amount  # Scroll speed
	
	$Sky.position.x -= screen_amount * 0.1
	$Hills.position.x -= screen_amount * 0.5
	$Stones.position.x -= screen_amount
