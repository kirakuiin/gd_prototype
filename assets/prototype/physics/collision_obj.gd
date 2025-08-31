extends CollisionObject2D

@export var origin_color: Color
@export var collide_color: Color

@onready var sprite: Sprite2D = $Sprite2D
@onready var layer_edit: LineEdit = $Label2
@onready var mask_edit: LineEdit = $Label3

func _ready():
	layer_edit.connect("text_changed", _update_layer)
	mask_edit.connect("text_changed", _update_mask)
	layer_edit.text = "1"
	mask_edit.text = "1"
	_update_layer("1")
	_update_mask("1")
	_change_color(origin_color)
	
func _update_mask(text: String):
	if not text.is_valid_int() or int(text) < 0:
		mask_edit.text = "0"
	if int(text) > 32:
		mask_edit.text = "32"

	var mask = int(mask_edit.text)-1
	collision_mask = 1 << mask if mask >= 0 else 0

func _update_layer(text: String):
	if not text.is_valid_int() or int(text) < 0:
		layer_edit.text = "0"
	if int(text) > 32:
		layer_edit.text = "32"

	var layer = int(layer_edit.text)-1
	collision_layer = 1 << layer if layer >= 0 else 0
	
func _change_color(color: Color):
	var m = sprite.material as ShaderMaterial
	m.set_shader_parameter("color", Vector4(color.r, color.g, color.b, color.a))

	
