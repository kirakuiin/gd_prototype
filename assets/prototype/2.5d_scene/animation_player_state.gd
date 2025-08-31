@tool
class_name AnimationPlayerState
extends LimboState
## 实现了[LimboState]的管理帧动画[SpriteFrames]的状态类


## 播放完毕释放的信号(仅单次会触发)
@export var event: String = "finish"


## 帧动画播放器
var _anim_player: AnimationPlayer


## 动画名称
var _anim_name: String


func _enter() -> void:
	_anim_player.animation_finished.connect(_on_anim_end)
	_anim_player.play(_anim_name)
	
	
func _exit() -> void:
	_anim_player.animation_finished.disconnect(_on_anim_end)


func _on_anim_end(anim_name: StringName) -> void:
	if event:
		dispatch(event)	
	
	
# 编辑器使用逻辑

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	# 动态动画选择属性
	var anim_names: PackedStringArray = get_animation_names()
	properties.append({
			"name": "anim_player",
			"hint": PROPERTY_HINT_NODE_TYPE,
			"hint_string": &"AnimationPlayer",
			"type": TYPE_OBJECT,
	})
	properties.append({
		"name": "anim_name",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(anim_names) if anim_names.size() > 0 else ""
	})

	return properties

	
func get_animation_names() -> PackedStringArray:
	if _anim_player == null or _anim_player.get_animation_list().is_empty():
		return []

	return _anim_player.get_animation_list()


func _notification(what: int) -> void:
	if not Engine.is_editor_hint():
		return
	match what:
		NOTIFICATION_EDITOR_POST_SAVE, NOTIFICATION_EDITOR_PRE_SAVE:
			# 在保存前更新动画列表
			notify_property_list_changed()
		
		
func _set(property: StringName, value: Variant) -> bool:
	update_configuration_warnings()
	if property == "anim_player":
		_anim_player = value as AnimationPlayer
		return true
	if property == "anim_name":
		_anim_name = str(value)
		return true
	return false
	
	
func _get(property: StringName) -> Variant:
	if property == "anim_player":
		return _anim_player
	if property == "anim_name":
		return _anim_name 
	return null
		

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()
	
	if _anim_player == null:
		warnings.append("需要指定Player(AnimationPlayer)")
	elif get_animation_names().size() == 0:
		warnings.append("目标AnimationPlayer没有动画")
	elif _anim_name == "":
		warnings.append("请选择一个动画")

	return warnings
	
	
