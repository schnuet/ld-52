class_name Player
extends KinematicBody2D

# Movement speed in pixels per second.
export var speed := 300
export var friction = 0.20

# We map a direction to a frame index of our AnimatedSprite node's sprite frames.
# See how we use it below to update the character's look direction in the game.
var _velocity := Vector2.ZERO
var _directions := {Vector2.RIGHT: "right", Vector2.LEFT: "left", Vector2.UP: "up", Vector2.DOWN: "down"}

# Last x/y direction the player moved in:
var last_x_direction = Vector2.RIGHT;
var last_y_direction = Vector2.DOWN;

onready var animated_sprite: AnimatedSprite = $AnimatedSprite;

func _ready():
	pass


# MOVEMENT

func _physics_process(_delta):
	
	# Once again, we call `Input.get_action_strength()` to support analog movement.
	var direction := Vector2(
		# This first line calculates the X direction, the vector's first component.
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		# And here, we calculate the Y direction. Note that the Y-axis points 
		# DOWN in games.
		# That is to say, a Y value of `1.0` points downward.
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	# When aiming the joystick diagonally, the direction vector can have a length 
	# greater than 1.0, making the character move faster than our maximum expected
	# speed. When that happens, we limit the vector's length to ensure the player 
	# can't go beyond the maximum speed.
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	# Using the follow steering behavior.
	var target_velocity = direction * speed
	_velocity += (target_velocity - _velocity) * friction
	_velocity = move_and_slide(_velocity)


# The code below updates the character's sprite to look in a specific direction.
func _unhandled_input(event):
	if event.is_action_pressed("right"):
		_update_direction(Vector2.RIGHT)
	elif event.is_action_pressed("left"):
		_update_direction(Vector2.LEFT)
	elif event.is_action_pressed("down"):
		_update_direction(Vector2.DOWN)
	elif event.is_action_pressed("up"):
		_update_direction(Vector2.UP)
		

func _update_direction(direction: Vector2) -> void:
	## Update the direction variables.
	
	if direction == Vector2.DOWN:
		last_y_direction = Vector2.DOWN;
	elif direction == Vector2.UP:
		last_y_direction = Vector2.UP;
	
	if direction == Vector2.RIGHT:
		last_x_direction = Vector2.RIGHT;
		animated_sprite.flip_h = false;
	if direction == Vector2.LEFT:
		last_x_direction = Vector2.LEFT;
		animated_sprite.flip_h = true;

