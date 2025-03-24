extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@export var jump_force = -400.0
@export_range(0, 1) var decelerate_on_jump_release = 0.5

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
    animated_sprite.play("Idle")

func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta
        
    if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
        if is_on_floor():
            animated_sprite.play("Walk")
        if not is_on_floor():
          animated_sprite.play("Jump")

    # Handle jump.
    if Input.is_action_just_pressed("Jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY
        animated_sprite.play("jump")
    if Input.is_action_just_released("Jump") and velocity.y:
        velocity.y *= decelerate_on_jump_release

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_axis("Left", "Right")
    if direction:
        velocity.x = direction * SPEED
        animated_sprite.play("Walk")
        animated_sprite.flip_h = direction < 0
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        animated_sprite.play("Idle")

    move_and_slide()
