extends Control

## 整个demo的总入口，主场景

## 场景配置
@export var ScenesInfo: Array[SceneCfg]


func _ready():
	_init_grid()

	
	
func _init_grid():
	for cfg in ScenesInfo:
		var node = _create_item(cfg)
		$GridContainer.add_child(node)


func _create_item(data: SceneCfg):
	var node = $Control.duplicate()
	node.call("set_data", data)
	return node
