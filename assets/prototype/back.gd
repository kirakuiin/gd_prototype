extends CanvasLayer


func init():
	$Button.button_down.connect(_on_click)

func _on_click():
	var main_scene := load("res://main.tscn")
	visible = false
	SceneManager.change_scene(main_scene, {"wait_time": 0.1})
