extends Control

func _ready() -> void:
	$HBoxContainer/Button.connect("button_down", _to_cn)
	$HBoxContainer/Button1.connect("button_down", _to_en)
	$HBoxContainer/Button2.connect("button_down", _to_ja)
	_init_cn()
	_format_str()
	
func _init_cn():
	_to_cn()
	
func _format_str():
	$VBoxContainer/Label6.text = tr("fmt").format({"a": 1, "b": 2})
	
func _to_cn():
	TranslationServer.set_locale("cn_CN")
	
	
func _to_en():
	TranslationServer.set_locale("en_US")
	

func _to_ja():
	TranslationServer.set_locale("ja")
	
	
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TRANSLATION_CHANGED:
			_format_str()
