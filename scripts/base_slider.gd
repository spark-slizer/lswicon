extends Panel

@onready var label = $Label
@onready var slider = $HSlider
@export var parameter_name:String
@export var value_ending:String
@export var min_value:float
@export var max_value:float
@export var initial_value:float

var value:float:
	set(new_value):
		slider.value = new_value
	get:
		return slider.value

func _ready():
	value = initial_value
	slider.min_value = min_value
	slider.max_value = max_value

func _process(_delta):
	label.text = parameter_name+": "+str(slider.value)+value_ending
