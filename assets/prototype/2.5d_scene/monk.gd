extends CharacterBody2D
## 武僧逻辑


## 运动速度
@export_range(100, 300, 1) var move_speed: int;

## 动画播放器
@export var animator: AnimationPlayer


## 动画库
@export var animate_sprite: AnimatedSprite2D

## 输入组件
@export var input_com: InputComponent

@export_group("状态机设置")

## 状态机
@export var state_machine: LimboHSM

@export var idle_state: AnimationPlayerState

@export var run_state: AnimationPlayerState

@export var heal_state: AnimationPlayerState


func _ready() -> void:
	_init_state_machine()
	_init_input()
	
	
func _init_state_machine() -> void:
	state_machine.add_transition(idle_state, run_state, "move")
	state_machine.add_transition(run_state, idle_state, "idle")
	state_machine.add_transition(idle_state, heal_state, "heal")
	state_machine.add_transition(run_state, heal_state, "heal")
	state_machine.add_transition(heal_state, idle_state, "idle")
	
	state_machine.initialize(self)
	state_machine.set_active(true)
	

func _init_input() -> void:
	input_com.InputTriggered.connect(_on_input_triggered)
	

func _on_input_triggered(action_name: String, value: Variant) -> void:
	match action_name:
		"move":
			var direction := value as Vector2
			move(direction)
		"action":
			heal()
			
		
## 移动角色
func move(direction: Vector2) -> void:
	if state_machine.get_active_state() == heal_state:
		return
	if direction.length() > 0:
		# 设置移动速度
		velocity = direction.normalized() * move_speed
		
		# 发送移动状态到状态机
		state_machine.dispatch("move")
		
		# 根据移动方向调整动画翻转
		if direction.x < 0:
			animate_sprite.flip_h = true
		elif direction.x > 0:
			animate_sprite.flip_h = false
	else:
		# 停止移动
		velocity = Vector2.ZERO
		state_machine.dispatch("idle")
	
	# 应用移动
	move_and_slide()
	
	
func heal():
	state_machine.dispatch("heal")


	
		
