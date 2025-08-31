extends "res://assets/prototype/physics/collision_obj.gd"

func _ready() -> void:
	super()
	connect("body_entered", _on_body_enter)
	connect("body_exited", _on_body_exit)
	
func _on_body_enter(body: Node):
	_change_color(collide_color)

func _on_body_exit(body: Node):
	_change_color(origin_color)
