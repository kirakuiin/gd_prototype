extends "res://assets/prototype/physics/collision_obj.gd"

func _ready() -> void:
	super()
	connect("area_entered", _on_enter)
	connect("area_exited", _on_exit)
	connect("body_entered", _on_enter)
	connect("body_exited", _on_exit)
	

func _on_enter(obj: Node2D):
	_change_color(collide_color)
	
func _on_exit(obj: Node2D):
	_change_color(origin_color)
