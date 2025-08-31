extends CharacterBody2D
## 战士逻辑

const ShapeCom = preload("res://assets/prototype/2.5d_scene/warrior_shape.gd")

## 运动速度
@export_range(100, 300, 1) var move_speed: int;

## 输入组件
@export var input_com: InputComponent

## 造型组件
@export var shape_com: ShapeCom


func _ready() -> void:
	_init_input()
		

func _init_input() -> void:
	input_com.InputTriggered.connect(_on_input_triggered)
	

func _on_input_triggered(action_name: String, value: Variant) -> void:
	match action_name:
		"move":
			move(value as Vector2)
		"action":
			action()
		"interact":
			interact(value as bool)
			
			
func move(direction: Vector2):
	if not shape_com.can_move():
		return
	shape_com.move(direction)
	velocity = direction.normalized()*move_speed
	move_and_slide()


func action():
	shape_com.attack()
	
	
func interact(is_guard: bool):
	if is_guard:
		shape_com.guard()
	else:
		shape_com.un_guard()
