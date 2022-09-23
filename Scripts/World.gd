extends Control

var mask1 = preload("res://Assets/mask1.png")
var mask2 = preload("res://Assets/mask2.png")
var mask3 = preload("res://Assets/mask3.png")
var mask4 = preload("res://Assets/mask4.png")

onready var lineedit = $Settings/Icon/MarginContainer/GridContainer/IconColour/LineEdit
onready var icon = $Control/Icon
onready var iconsprite = $Control/IconSprite
onready var posx = $Settings/Icon/MarginContainer/GridContainer/XPos/HSlider
onready var posy = $Settings/Icon/MarginContainer/GridContainer/YPos/HSlider
onready var posxl = $Settings/Icon/MarginContainer/GridContainer/XPos/Label
onready var posyl = $Settings/Icon/MarginContainer/GridContainer/YPos/Label
onready var scaleinput = $Settings/Icon/MarginContainer/GridContainer/Scale/LineEdit
onready var rot = $Settings/Mask/MarginContainer/GridContainer/Angle/HSlider
onready var type = $Settings/Mask/MarginContainer/GridContainer/Type/HSlider

func _ready():
	get_tree().get_root().set_transparent_background(true)

func _process(delta):
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	if lineedit.text.length() > 5:
		icon.modulate = Color(lineedit.text)
	else:
		icon.modulate = Color(1,1,1)
	
	if type.value == 1:
		$Control/Mask.texture = mask1
	elif type.value == 2:
		$Control/Mask.texture = mask2
	elif type.value == 3:
		$Control/Mask.texture = mask3
	else:
		$Control/Mask.texture = mask4
	
	posxl.text = "X Position: "+str(posx.value)
	posyl.text = "Y Position: "+str(posy.value)
	iconsprite.position = Vector2(posx.value, posy.value)
	iconsprite.scale = Vector2(float(scaleinput.text), float(scaleinput.text))
	$Settings/Mask/MarginContainer/GridContainer/Type/Label.text = "Type: "+str(type.value)
	$Settings/Mask/MarginContainer/GridContainer/Angle/Label.text = "Angle: "+str(rot.value)+"°"
	$Control/Mask.rotation_degrees = rot.value

func _on_Blue_pressed():
	lineedit.text = "0370FF"

func _on_Green_pressed():
	lineedit.text = "21C600"

func _on_Import_pressed():
	$FileDialog.popup()

func _on_CheckButton_toggled(button_pressed):
	$Control/Mask.enabled = button_pressed

func _on_FileDialog_file_selected(path):
	var image = Image.new()
	image.load(path)
	var texture = ImageTexture.new()
	texture.create_from_image(image, 4)
	iconsprite.texture = texture

func _on_Render_pressed():
	$Control.rect_scale = Vector2(1,1)
	$FileDialog2.popup()

func _on_FileDialog2_file_selected(path):
	yield(get_tree().create_timer(0.5), "timeout")
	save_to(path)
	$Control.rect_scale = Vector2(3,3)

func _on_FileDialog2_popup_hide():
	yield(get_tree().create_timer(0.5), "timeout")
	$Control.rect_scale = Vector2(3,3)

export(NodePath) var viewport_path = null

onready var target_viewport = get_node(viewport_path) if viewport_path else get_tree().root.get_viewport()

func save_to(path):
	var img = target_viewport.get_texture().get_data()
	img.flip_y()
	img.crop(128,128)
	img.convert(Image.FORMAT_RGBA8)
	return img.save_png(path)
