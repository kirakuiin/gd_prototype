extends Node2D
## 战士逻辑


## 动画播放器
@export var animator: AnimationPlayer

## 动画库
@export var animate_sprite: AnimatedSprite2D


@export_group("状态机设置")

## 状态机
@export var state_machine: LimboHSM

@export var idle_state: AnimationPlayerState

@export var run_state: AnimationPlayerState

@export var guard_state: AnimationPlayerState

@export var attack1_state: AnimationPlayerState

@export var attack2_state: AnimationPlayerState

@export var switch_state: AnimationPlayerState


var _cur_atk_evt: String = "attack1"


func _ready() -> void:
	_init_state_machine()
	
	
func _init_state_machine() -> void:
	state_machine.add_transition(idle_state, run_state, "move")
	state_machine.add_transition(run_state, idle_state, "idle")
	state_machine.add_transition(idle_state, attack1_state, "attack1")
	state_machine.add_transition(run_state, attack1_state, "attack1")
	state_machine.add_transition(attack1_state, switch_state, "switch")
	state_machine.add_transition(attack2_state, switch_state, "switch")
	state_machine.add_transition(switch_state, attack1_state, "attack1")
	state_machine.add_transition(switch_state, attack2_state, "attack2")
	state_machine.add_transition(switch_state, idle_state, "idle")
	state_machine.add_transition(idle_state, guard_state, "guard")
	state_machine.add_transition(run_state, guard_state, "guard")
	state_machine.add_transition(attack1_state, guard_state, "guard")
	state_machine.add_transition(attack2_state, guard_state, "guard")
	state_machine.add_transition(guard_state, idle_state, "idle")
	
	state_machine.initialize(self)
	state_machine.set_active(true)
	
		
## 移动角色
func move(direction: Vector2) -> void:
	if direction.length() > 0:
		# 发送移动状态到状态机
		state_machine.dispatch("move")
		# 根据移动方向调整动画翻转
		if direction.x < 0:
			self.set_flip(true)
		elif direction.x >= 0:
			self.set_flip(false)
		_cur_atk_evt = "attack1"
	else:
		state_machine.dispatch("idle")
	
	
## 设置反转
func set_flip(is_flip: bool):
	self.scale.x = -1 if is_flip else 1
		
## 空闲
func idle():
	_cur_atk_evt = "attack1"


## 攻击
func attack():
	state_machine.dispatch(_cur_atk_evt)
	
## 是否在防御状态
func is_guard() -> bool:
	return state_machine.get_active_state() == guard_state
	
## 是否在进攻状态
func is_attack() -> bool:
	return state_machine.get_active_state() in [attack1_state, attack2_state]
	
## 是否可以移动
func can_move() -> bool:
	return not (is_guard() or is_attack())

# 防御
func guard():
	state_machine.dispatch("guard")
	
# 取消防御
func un_guard():
	if state_machine.get_active_state() == guard_state:
		state_machine.dispatch("idle")
	
# 等待
func switch():
	_cur_atk_evt = "attack1" if _cur_atk_evt != "attack1" else "attack2"
	
