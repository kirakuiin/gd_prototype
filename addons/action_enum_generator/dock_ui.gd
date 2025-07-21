@tool
extends Control

signal generate_requested(output_path: String, file_name: String, cls_name: String)

const SETTING_OUTPUT_PATH = "action_enum_generator/output_path"
const SETTING_FILE_NAME = "action_enum_generator/file_name"
const SETTING_CLASS_NAME = "action_enum_generator/class_name"
const DEFAULT_OUTPUT_PATH = "addons"
const DEFAULT_FILE_NAME = "InputActions.cs"
const DEFAULT_CLASS_NAME = "EInputAction"

@onready var path_line_edit: LineEdit = $VBoxContainer/PathContainer/PathLineEdit
@onready var edit_button: Button = $VBoxContainer/PathContainer/EditButton
@onready var file_name_line_edit: LineEdit = $VBoxContainer/FileNameContainer/FileNameLineEdit
@onready var file_name_edit_button: Button = $VBoxContainer/FileNameContainer/FileNameEditButton
@onready var class_name_line_edit: LineEdit = $VBoxContainer/ClassNameContainer/ClassNameLineEdit
@onready var class_name_edit_button: Button = $VBoxContainer/ClassNameContainer/ClassNameEditButton
@onready var generate_button: Button = $VBoxContainer/GenerateButton

var path_editing = false
var file_name_editing = false
var class_name_editing = false
var file_dialog: EditorFileDialog

func _ready():
	# 加载保存的设置
	var saved_path = ProjectSettings.get_setting(SETTING_OUTPUT_PATH, DEFAULT_OUTPUT_PATH)
	var saved_file_name = ProjectSettings.get_setting(SETTING_FILE_NAME, DEFAULT_FILE_NAME)
	var saved_class_name = ProjectSettings.get_setting(SETTING_CLASS_NAME, DEFAULT_CLASS_NAME)
	
	path_line_edit.text = saved_path
	file_name_line_edit.text = saved_file_name
	class_name_line_edit.text = saved_class_name
	
	# 连接信号
	edit_button.pressed.connect(_on_edit_button_pressed)
	file_name_edit_button.pressed.connect(_on_file_name_edit_button_pressed)
	class_name_edit_button.pressed.connect(_on_class_name_edit_button_pressed)
	generate_button.pressed.connect(_on_generate_button_pressed)
	
	# 创建文件对话框
	file_dialog = EditorFileDialog.new()
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	file_dialog.current_dir = "res://"
	file_dialog.dir_selected.connect(_on_dir_selected)
	add_child(file_dialog)

func _on_edit_button_pressed():
	if not path_editing:
		# 使用文件对话框选择目录
		file_dialog.popup_centered_ratio(0.8)
	else:
		# 保存模式
		_save_path()

func _on_dir_selected(dir: String):
	# 移除 "res://" 前缀
	if dir.begins_with("res://"):
		dir = dir.substr(6)
	path_line_edit.text = dir
	_save_path()

func _save_path():
	var output_path = path_line_edit.text.strip_edges()
	
	if output_path.is_empty():
		path_line_edit.text = DEFAULT_OUTPUT_PATH
		output_path = DEFAULT_OUTPUT_PATH
	
	# 保存路径到项目设置
	ProjectSettings.set_setting(SETTING_OUTPUT_PATH, output_path)
	ProjectSettings.save()
	
	print("路径已保存: ", output_path)

func _on_file_name_edit_button_pressed():
	if not file_name_editing:
		# 进入编辑模式
		file_name_editing = true
		file_name_line_edit.editable = true
		file_name_edit_button.text = "保存"
		file_name_line_edit.grab_focus()
	else:
		# 保存模式
		_save_file_name()

func _save_file_name():
	var file_name = file_name_line_edit.text.strip_edges()
	
	if file_name.is_empty():
		file_name_line_edit.text = DEFAULT_FILE_NAME
		file_name = DEFAULT_FILE_NAME
	
	# 确保文件名以.cs结尾
	if not file_name.ends_with(".cs"):
		file_name += ".cs"
		file_name_line_edit.text = file_name
	
	# 保存到项目设置
	ProjectSettings.set_setting(SETTING_FILE_NAME, file_name)
	ProjectSettings.save()
	
	# 退出编辑模式
	file_name_editing = false
	file_name_line_edit.editable = false
	file_name_edit_button.text = "编辑"
	
	print("文件名已保存: ", file_name)

func _on_class_name_edit_button_pressed():
	if not class_name_editing:
		# 进入编辑模式
		class_name_editing = true
		class_name_line_edit.editable = true
		class_name_edit_button.text = "保存"
		class_name_line_edit.grab_focus()
	else:
		# 保存模式
		_save_class_name()

func _save_class_name():
	var cls_name = class_name_line_edit.text.strip_edges()
	
	if cls_name.is_empty():
		class_name_line_edit.text = DEFAULT_CLASS_NAME
		cls_name = DEFAULT_CLASS_NAME
	
	# 保存到项目设置
	ProjectSettings.set_setting(SETTING_CLASS_NAME, cls_name)
	ProjectSettings.save()
	
	# 退出编辑模式
	class_name_editing = false
	class_name_line_edit.editable = false
	class_name_edit_button.text = "编辑"
	
	print("类名已保存: ", cls_name)

func _on_generate_button_pressed():
	var output_path = path_line_edit.text.strip_edges()
	var file_name = file_name_line_edit.text.strip_edges()
	var cls_name = class_name_line_edit.text.strip_edges()
	
	if output_path.is_empty():
		output_path = DEFAULT_OUTPUT_PATH
	if file_name.is_empty():
		file_name = DEFAULT_FILE_NAME
	if cls_name.is_empty():
		cls_name = DEFAULT_CLASS_NAME
	
	generate_requested.emit(output_path, file_name, cls_name)
