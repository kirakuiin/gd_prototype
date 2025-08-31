extends Area2D

## 箭矢

@onready var screen_notifer: VisibleOnScreenNotifier2D = $Visible


@export var arrow_data: ArrowData


var _velocity: Vector2

## 速度
var velocity: Vector2:
	get: return _velocity
	set(value): _velocity = value


## 方向
var direction: Vector2:
	get:
		return _velocity.normalized()
	set(value):
		_velocity = speed * value
		

## 速率
var speed: float:
	get:
		return _velocity.length()
	set(value):
		_velocity = direction * value
			

func _ready() -> void:
	screen_notifer.screen_exited.connect(queue_free)
	body_entered.connect(_on_collision)
	velocity = arrow_data.Speed * Vector2(1, 1)
	
	
func _physics_process(delta: float) -> void:
	position += delta * velocity
	rotation = velocity.angle()
	

func _on_collision(body: Node2D):
	pass
