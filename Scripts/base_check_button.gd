extends Panel

@onready var label = $Label
@onready var check_button = $CheckButton
@export var parameter_name:String
@export var value:bool

signal toggled(button_pressed)

func _ready():
	check_button.button_pressed = value
	label.text = parameter_name

func _process(_delta):
	value = check_button.button_pressed

func _on_check_button_toggled(button_pressed):
	toggled.emit(button_pressed)
