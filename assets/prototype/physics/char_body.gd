extends "res://assets/prototype/physics/collision_obj.gd"

var body: CharacterBody2D

func _physics_process(delta: float) -> void:
	call("move_and_slide")
