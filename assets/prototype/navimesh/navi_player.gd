extends CharacterBody2D


@export var movement_speed: float = 200.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


var _target_pos: Vector2 = Vector2(0, 0)


func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	navigation_agent.velocity_computed.connect(_on_velocity_computed)

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(_target_pos)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target
	
func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished() or _target_pos == Vector2.ZERO:
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(velocity)
	else:
		_on_velocity_computed(velocity)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_target_pos = get_global_mouse_position()
			actor_setup()
			print(_target_pos)
			
		
