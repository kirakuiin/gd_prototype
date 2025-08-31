extends CharacterBody2D
## 弓箭手逻辑


## 运动速度
@export_range(100, 300, 1) var move_speed: int;

## 动画播放器
@export var animator: AnimationPlayer


## 动画库
@export var animate_sprite: AnimatedSprite2D

## 输入组件
@export var input_com: InputComponent

## 射击点
@export var shoot_point: Marker2D


@export_group("状态机设置")

## 状态机
@export var state_machine: LimboHSM

@export var idle_state: AnimationPlayerState

@export var run_state: AnimationPlayerState

@export var shoot_state: AnimationPlayerState

const ArrowScene: PackedScene = preload("res://assets/prototype/2.5d_scene/arrow.tscn")

const Arrow = preload("res://assets/prototype/2.5d_scene/arrow.gd")


func _ready() -> void:
	_init_state_machine()
	_init_input()
	
	
func _init_state_machine() -> void:
	state_machine.add_transition(idle_state, run_state, "move")
	state_machine.add_transition(idle_state, shoot_state, "shoot")
	state_machine.add_transition(run_state, idle_state, "idle")
	state_machine.add_transition(run_state, shoot_state, "shoot")
	state_machine.add_transition(shoot_state, idle_state, "idle")
	
	state_machine.initialize(self)
	state_machine.set_active(true)
	

func _init_input() -> void:
	input_com.InputTriggered.connect(_on_input_triggered)
	

func _on_input_triggered(action_name: String, value: Variant) -> void:
	match action_name:
		"move":
			var direction := value as Vector2
			if state_machine.get_active_state() != shoot_state:
				move(direction)
		"action":
			shoot()
			
		
## 移动角色
func move(direction: Vector2) -> void:
	if direction.length() > 0:
		# 设置移动速度
		velocity = direction.normalized() * move_speed
		
		# 发送移动状态到状态机
		state_machine.dispatch("move")
		
		# 根据移动方向调整动画翻转
		if direction.x < 0:
			animate_sprite.flip_h = true
			shoot_point.position.x = -abs(shoot_point.position.x)
		elif direction.x > 0:
			animate_sprite.flip_h = false
			shoot_point.position.x = abs(shoot_point.position.x)
	else:
		# 停止移动
		velocity = Vector2.ZERO
		state_machine.dispatch("idle")
	
	# 应用移动
	move_and_slide()
	

func shoot() -> void:
	state_machine.dispatch("shoot")


## 发出箭矢
func make_arrow():
	var arrow := ArrowScene.instantiate() as Arrow
	arrow.direction = Vector2(1, 1)
	arrow.global_position = shoot_point.global_position
	get_tree().root.add_child(arrow)
	
		
