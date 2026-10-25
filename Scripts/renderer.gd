class_name LevelGenerator
extends Node2D

@export var start_chunk: PackedScene          # level awal (root)
@export var chunk_scenes: Array[PackedScene] = [preload("uid://b7l4ehjkwu6jk")] # sisa level
@export var chunks_ahead := 3

var player: Node2D
var active_chunks: Array[Chunk] = []
var next_spawn_pos := Vector2.ZERO
var last_index := -1
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	_spawn(start_chunk, false)          
	for i in chunks_ahead - 1:
		_spawn(_pick_random_scene())

func _process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return

	var last := active_chunks.back() as Chunk
	if player.global_position.x > last.get_exit_global_position().x - 1500.0:
		_spawn(_pick_random_scene())
		_cleanup()


func _pick_random_scene() -> PackedScene:
	var index := rng.randi() % chunk_scenes.size()
	if chunk_scenes.size() > 1:
		while index == last_index:
			index = rng.randi() % chunk_scenes.size()
	last_index = index
	return chunk_scenes[index]


func _spawn(scene: PackedScene, align := true) -> void:
	var chunk := scene.instantiate() as Chunk
	add_child(chunk)
	if align:
		chunk.align_to(next_spawn_pos)
	chunk.on_spawned()
	next_spawn_pos = chunk.get_exit_global_position()
	active_chunks.append(chunk)


func _cleanup() -> void:
	while active_chunks.size() > chunks_ahead + 2:
		active_chunks.pop_front().queue_free()
