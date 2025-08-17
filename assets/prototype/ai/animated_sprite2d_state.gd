@tool
class_name AnimatedSprite2DState
extends LimboState
## 实现了[LimboState]的管理帧动画[SpriteFrames]的状态类

## 动画开始事件
const EVENT_ANIM_START: StringName = &"start";
## 动画结束事件
const EVENT_ANIM_FINISH: StringName = &"finish";
## 动画击中事件
const EVENT_ANIM_HIT: StringName = &"hit";
## 特殊动画事件
const EVENT_ANIM_SPECIAL: StringName = &"special";


## 帧动画播放器
var _anim_player: AnimatedSprite2D


## 动画名称
var _anim_name: String


func _setup() -> void:
	pass


func _enter() -> void:
	_anim_player.play(_anim_name)
	

func _exit() -> void:
	pass
	
	
# 编辑器使用逻辑

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	# 动态动画选择属性
	var anim_names: PackedStringArray = get_animation_names()
	properties.append({
			"name": "anim_player",
			"hint": PROPERTY_HINT_NODE_TYPE,
			"hint_string": &"AnimatedSprite2D",
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
	if _anim_player == null or _anim_player.sprite_frames == null:
		return []

	return _anim_player.sprite_frames.get_animation_names()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_POST_SAVE, NOTIFICATION_EDITOR_PRE_SAVE:
			# 在保存前更新动画列表
			notify_property_list_changed()
		
		
func _set(property: StringName, value: Variant) -> bool:
	update_configuration_warnings()
	if property == "anim_player":
		_anim_player = value as AnimatedSprite2D
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
		warnings.append("需要指定TargetSprite(AnimatedSprite2D)")
	elif get_animation_names().size() == 0:
		warnings.append("目标AnimatedSprite2D没有动画")
	elif _anim_name == "":
		warnings.append("请选择一个动画")

	return warnings
	
	
