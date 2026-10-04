extends Control
signal start_game
var starting := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_menu"):
		if visible:
			return

		get_tree().paused = true
		open_menu()




func _on_start_button_pressed() -> void:
	if starting: # checks if ts already started or nah
		return
	starting = true
	
	# make this node disappear type shi
	var tween := create_tween() #make the tween
	tween.tween_property(self, "modulate:a", 0.0, 1.0) # the parameters n stuff
	await tween.finished # tells it to wait until bro is finished
	hide() # then hide the node
	start_game.emit() #idfk im still trying to understand, but ik that it's to send a signal that the game is running

func open_menu() -> void:
	if starting:
		return
	
	if visible:
		return
	
	modulate.a = 0.0
	show()
	
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
