class_name Chunk
extends Node2D

@onready var entry: Marker2D = $Entry
@onready var exit: Marker2D = $Exit

# Child classes override this to do their own setup (polymorphism)
func on_spawned() -> void:
	pass

func get_exit_global_position() -> Vector2:
	return exit.global_position

func align_to(point: Vector2) -> void:
	global_position = point - entry.position
