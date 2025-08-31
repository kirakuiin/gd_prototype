extends Node2D

enum LEAVE_DIR {N, S, E, W}

@export var leave_dir: LEAVE_DIR 

@onready var area: Area2D = $Sprite2D/Entrance


## 进入楼梯
signal stair_entered(body: Node2D)

## 离开楼梯
signal stair_left(body: Node2D)


func _ready() -> void:
	area.body_entered.connect(self._on_body_entered)
	area.body_exited.connect(self._on_body_exited)
	
	
func _on_body_entered(body: Node2D):
	stair_entered.emit(body)
	
	
func _on_body_exited(body: Node2D):
	var offset := body.global_position - area.global_position
	match leave_dir:
		LEAVE_DIR.E:
			if offset.x > 0:
				stair_left.emit(body)
		LEAVE_DIR.W:
			if offset.x < 0:
				stair_left.emit(body)
		LEAVE_DIR.N:
			if offset.y < 0:
				stair_left.emit(body)
		LEAVE_DIR.S:
			if offset.y > 0:
				stair_left.emit(body)
			
