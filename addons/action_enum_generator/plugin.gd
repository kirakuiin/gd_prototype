@tool
extends EditorPlugin

var dock_ui: Control

func _enter_tree():
	# 创建停靠窗口UI
	dock_ui = preload("res://addons/action_enum_generator/dock_ui.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock_ui)
	
	# 连接信号
	dock_ui.generate_requested.connect(_on_generate_requested)

func _exit_tree():
	if dock_ui:
		remove_control_from_docks(dock_ui)
		dock_ui.queue_free()

func _on_generate_requested(output_path: String, file_name: String, cls_name: String):
	print("开始生成输入动作静态类...")
	
	var success = _generate_input_actions(output_path, file_name, cls_name)
	if success:
		var full_path = output_path + "/" + file_name
		print("生成成功: ", full_path)
		print("重要提示: 请点击编辑器右上角的 'Build' 按钮来重新编译 C# 项目，以使更改生效。")
	else:
		print("生成失败")

func _generate_input_actions(output_path: String, file_name: String, cls_name: String) -> bool:
	# 确保从项目设置加载输入映射
	InputMap.load_from_project_settings()
	
	# 获取输入动作
	var actions = InputMap.get_actions()
	var filtered_actions = []
	
	for action in actions:
		var action_str = str(action)
		# 过滤掉包含点号、斜线和ui前缀的动作，只保留用户自定义的动作
		if not action_str.contains(".") and not action_str.contains("/") and not action_str.begins_with("ui"):
			filtered_actions.append(action_str)
	
	if filtered_actions.is_empty():
		print("没有找到可用的输入动作")
		return false
	
	# 生成C#代码
	var code_lines = ["public class %s {" % cls_name]
	
	for action in filtered_actions:
		var constant_name = _to_pascal_case(action)
		code_lines.append("\tpublic const string %s = \"%s\";" % [constant_name, action])
	
	code_lines.append("}")
	
	var content = "\n".join(code_lines) + "\n"
	
	# 构建完整路径
	var full_path = "res://" + output_path + "/" + file_name
	
	# 确保目录存在
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(output_path):
		dir.make_dir_recursive(output_path)
	
	# 写入文件
	var file = FileAccess.open(full_path, FileAccess.WRITE)
	if file == null:
		print("无法创建文件: ", full_path)
		return false
	
	file.store_string(content)
	file.close()
	
	return true

func _to_pascal_case(snake_case: String) -> String:
	var parts = snake_case.split("_")
	var result = ""
	
	for part in parts:
		if part.length() > 0:
			result += part.capitalize()
	
	return result
