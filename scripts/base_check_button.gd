extends Panel

@onready var label = $Label
@onready var check_button = $CheckButton
@export var parameter_name:String
@export var initial_value:bool

signal toggled(button_pressed)
var value:bool:
	set(new_value):
		check_button.button_pressed = new_value
	get:
		return check_button.button_pressed

func _ready():
	value = initial_value
	label.text = parameter_name

func _on_check_button_toggled(button_pressed):
	toggled.emit(button_pressed)
