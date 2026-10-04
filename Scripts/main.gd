extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# pause le game
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# unpause game after  main menu un-necromanced
func _on_main_menu_start_game() -> void:
	get_tree().paused = false	
