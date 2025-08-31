extends Node

## 鼠标可拖动物理体组件
## 支持拖动时屏蔽物理效果，松开后根据鼠标速度施加力

@export var enable_dragging: bool = true
@export var throw_multiplier: float = 1.0  ## 抛出力度倍数
@export var max_throw_speed: float = 1000.0  ## 最大抛出速度
@export var drag_smoothness: float = 0.1  ## 拖动平滑度

var _physics_body: CollisionObject2D
var _camera: Camera2D
var _is_dragging: bool = false
var _drag_start_mouse_pos: Vector2
var _drag_offset: Vector2  # 鼠标点击位置与物体中心的偏移
var _last_mouse_pos: Vector2
var _drag_velocity: Vector2


func _ready():
	_physics_body = get_parent()
	if not _physics_body is CollisionObject2D:
		push_error("MouseDraggableBody2D必须添加到PhysicsBody2D节点下")
		return

	_camera = get_viewport().get_camera_2d()

func _input(event):
	if not enable_dragging or not _physics_body:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not _is_dragging:
				# 检查鼠标是否点击在物体上
				if is_mouse_over_body(event.position):
					start_dragging(event.position)
			elif not event.pressed and _is_dragging:
				stop_dragging()
	elif event is InputEventMouseMotion and _is_dragging:
		update_dragging(event.position)


func is_mouse_over_body(mouse_pos: Vector2) -> bool:
	if not _camera:
		return false
	
	var world_mouse_pos = _camera.get_global_mouse_position()
	
	# 检查鼠标是否在物理体的形状范围内
	for child in _physics_body.get_children():
		if child is CollisionShape2D:
			var shape = child.shape
			if shape:
				var local_pos = _physics_body.to_local(world_mouse_pos)
				return shape.get_rect().has_point(local_pos)
	
	# 如果没有碰撞形状，检查整体范围
	return _physics_body.get_rect().has_point(_physics_body.to_local(world_mouse_pos))

func start_dragging(mouse_pos: Vector2):
	_is_dragging = true
	var global_mouse_pos = get_global_mouse_position()
	_drag_start_mouse_pos = _physics_body.global_position  # 记录物体开始拖动的位置
	_drag_offset = _physics_body.global_position - global_mouse_pos  # 记录偏移量
	_last_mouse_pos = global_mouse_pos
	
	print("开始拖动")

func update_dragging(mouse_pos: Vector2):
	if not _is_dragging:
		return
	
	var global_mouse_pos = get_global_mouse_position()
	_physics_body.global_position = global_mouse_pos + _drag_offset  # 应用偏移量
	_last_mouse_pos = global_mouse_pos

func stop_dragging():
	if not _is_dragging:
		return
	
	_is_dragging = false
	
	
	# 计算从拖动起点到终点的向量
	var throw_velocity = (_physics_body.global_position - _drag_start_mouse_pos) * throw_multiplier
	throw_velocity = throw_velocity.limit_length(max_throw_speed)
	
	# 应用速度
	if _physics_body is CharacterBody2D:
		_physics_body.velocity = throw_velocity
	if _physics_body is RigidBody2D:
		_physics_body.linear_velocity = throw_velocity
	
	print("抛出速度: ", throw_velocity)
	print("停止拖动")


func get_global_mouse_position() -> Vector2:
	if not _camera:
		return get_viewport().get_mouse_position()
	
	return _camera.get_global_mouse_position()

func set_enable_dragging(enable: bool):
	enable_dragging = enable
	if not enable and _is_dragging:
		stop_dragging()
