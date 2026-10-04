extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# basic movement
const SPEED = 450.0
const JUMP_VELOCITY = -800.0
var direction := Input.get_axis("leftmove", "rightmove")


# double jump
const JUMPS_ALLOWED = 2
var jumps_left: int = JUMPS_ALLOWED


# for dash stuff
const DASH_SPEED = 1500.0
const DASH_ALLOWED = 1
var dash_left: int = DASH_ALLOWED
var dashing: bool = false


# respawn stuff pt 1
var starting_position: Vector2
func _ready() -> void:
	starting_position = position

# now we allow stuff to happen
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("leftmove", "rightmove")
	# respawn stuff pt 2
	if position.y > 1500:
		position = starting_position
		velocity = Vector2.ZERO

	# grav
	if not is_on_floor():
		velocity += get_gravity() * delta

	# jump reset
	if is_on_floor():
		jumps_left = JUMPS_ALLOWED
		dash_left = DASH_ALLOWED

	# necromandoublejump
	if Input.is_action_just_pressed("jumpmove") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1
		animated_sprite_2d.animation = "Jump"

	# necromandash
	if Input.is_action_just_pressed("dash") and dash_left > 0 and not dashing:
		# dash direction (if move) if no move then dash where face is facing idk how to explain
		if direction != 0:
			velocity.x = direction * DASH_SPEED
		else:
			if animated_sprite_2d.flip_h: # default is left facing so we make this for right facing yeah
				velocity.x = DASH_SPEED
			else:
				velocity.x = -DASH_SPEED

		dash_left -= 1 # -1 aura
		dashing = true
		animated_sprite_2d.animation = "Dash"
		$dashtimer.start()
		
	#basic movement
	if not dashing:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	
	# animation section, dash -> jump -> walk -> silent
	if dashing:
		animated_sprite_2d.animation = "Dash"
	elif not is_on_floor():
		animated_sprite_2d.animation = "Jump"
	elif velocity.x > 0 or velocity.x < 0:
		animated_sprite_2d.animation = "Walk"
	else:
		animated_sprite_2d.animation = "Idle"

	if direction > 0:
		animated_sprite_2d.flip_h = true
	elif direction < 0:
		animated_sprite_2d.flip_h = false

	move_and_slide()


	# dash end & le cooldown
func _on_dashtimer_timeout() -> void:
	dashing = false
	velocity.x = 0
	$dashwaittimer.start()

func _on_dashwaittimer_timeout() -> void:
	dash_left = DASH_ALLOWED
