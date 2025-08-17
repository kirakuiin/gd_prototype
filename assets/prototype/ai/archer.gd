class_name Archer
extends CharacterBody2D
## 弓箭手逻辑


## 运动速度
@export_range(100, 300, 1) var move_speed: int;

@export_group("状态机设置")

## 状态机
@export var state_machine: LimboHSM

@export var idle_state: AnimatedSprite2DState

@export var run_state: AnimatedSprite2DState

@export var shoot_state: AnimatedSprite2DState

@export var input_com: InputComponent


func _ready() -> void:
	_init_state_machine()
	_init_input()
	
	
func _init_state_machine() -> void:
	state_machine.add_transition(idle_state, run_state, "move")
	state_machine.add_transition(idle_state, shoot_state, "shoot")
	state_machine.add_transition(run_state, idle_state, "idle")
	state_machine.add_transition(shoot_state, idle_state, "idle")
	
	state_machine.initialize(self)
	state_machine.set_active(true)
	

func _init_input() -> void:
	input_com.InputTriggered.connect(_on_input_triggered)
	

func _on_input_triggered(action_name: String, value: Variant) -> void:
	match action_name:
		"move":
			print("move triggered", value as Vector2)
		"action":
			print("action triggered", value)
		
