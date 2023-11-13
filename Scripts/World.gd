extends Control

@onready var mask_viewport = $MaskViewport
@onready var mask = mask_viewport.get_node("Mask")
@onready var icon = $Control/Icon
@onready var icon_sprite = $Control/IconSprite
@onready var icon_mask_sprite = $Control/Icon/IconMaskSprite
@onready var icon_colour = $Settings/Icon/GridContainer/IconColour/LineEdit
@onready var x_position = $Settings/Icon/GridContainer/XPosition
@onready var y_position = $Settings/Icon/GridContainer/YPosition
@onready var icon_scale_input = $Settings/Icon/GridContainer/Scale/LineEdit
@onready var type = $Settings/Mask/GridContainer/Type
@onready var angle = $Settings/Mask/GridContainer/Angle
@onready var brush_size = $Settings/Draw/GridContainer/BrushSize
@onready var draw_mode = $Settings/Draw/GridContainer/DrawMode
@onready var open_file = $OpenFile
@onready var save_file = $SaveFile

var mask1 = preload("res://assets/mask1.png")
var mask2 = preload("res://assets/mask2.png")
var mask3 = preload("res://assets/mask3.png")
var mask4 = preload("res://assets/mask4.png")
var image_type:bool
var pressed := false
var current_line:Line2D

func _ready():
	icon_sprite.material.set_shader_parameter("mask", mask_viewport.get_texture())
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		pressed = event.pressed
		
		if pressed and draw_mode.value:
			current_line = Line2D.new()
			current_line.antialiased = true
			current_line.width = brush_size.value
			current_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
			current_line.end_cap_mode = Line2D.LINE_CAP_ROUND
			current_line.joint_mode = Line2D.LINE_JOINT_ROUND
			mask_viewport.add_child(current_line)
	
	if event is InputEventMouseMotion and pressed and draw_mode.value:
		current_line.add_point(Vector2(event.position.x / 0.75, event.position.y / 0.75))

func _process(_delta):
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	if icon_colour.text.length() > 5:
		icon.modulate = Color(icon_colour.text)
	else:
		icon.modulate = Color(1,1,1)
	
	if type.value == 1:
		mask.texture = mask1
	elif type.value == 2:
		mask.texture = mask2
	elif type.value == 3:
		mask.texture = mask3
	else:
		mask.texture = mask4
	
	icon_sprite.scale = Vector2(float(icon_scale_input.text), float(icon_scale_input.text))
	icon_sprite.position = Vector2(x_position.value - 256, y_position.value - 256)
	mask.rotation_degrees = angle.value

func _on_icon_colour_blue_pressed():
	icon_colour.text = "0370FF"

func _on_icon_colour_green_pressed():
	icon_colour.text = "21C600"

func _on_icon_image_pressed():
	image_type = true
	open_file.show()

func _on_icon_mask_image_pressed():
	image_type = false
	open_file.show()

func _on_clear_drawing_pressed():
	for i in mask_viewport.get_children():
		if i is Line2D:
			i.clear_points()

func _on_render_button_pressed():
	$Control.scale = Vector2(1,1)
	icon_sprite.material.set_shader_parameter("scale", 1.0)
	$Settings.visible = false
	$Label.visible = false
	save_file.show()

func _on_mask_enabled_toggled(button_pressed):
	if icon_sprite:
		icon_sprite.material.set_shader_parameter("enabled", button_pressed)

func _on_icon_mask_enabled_toggled(button_pressed):
	icon_mask_sprite.visible = button_pressed

func _on_open_file_selected(path):
	var image = Image.new()
	image.load(path)
	var texture = ImageTexture.create_from_image(image)
	if image_type:
		icon_sprite.texture = texture
	else:
		icon_mask_sprite.texture = texture
		var icon_mask_scale = (1/min(icon_mask_sprite.texture.get_size().x, icon_mask_sprite.texture.get_size().y))*512
		icon_mask_sprite.scale = Vector2(icon_mask_scale, icon_mask_scale)

func _on_save_file_selected(path):
	await get_tree().create_timer(0.1).timeout
	save_to(path)
	$Control.scale = Vector2(0.75,0.75)
	icon_sprite.material.set_shader_parameter("scale", 0.75)
	$Settings.visible = true
	$Label.visible = true

func _on_save_file_cancelled():
	$Control.scale = Vector2(0.75,0.75)
	icon_sprite.material.set_shader_parameter("scale", 0.75)
	$Settings.visible = true
	$Label.visible = true

func save_to(path):
	var img = get_viewport().get_texture().get_image()
	img.crop(512,512)
	img.convert(Image.FORMAT_RGBA8)
	if !path.to_lower().ends_with(".png"):
		path += ".png"
	return img.save_png(path)

func _on_settings_tab_changed(_tab):
	draw_mode.value = false
