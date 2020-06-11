#Author: Rodrigo Torres
#Version: 1.1.0
#For Godot 3.x
# Module used to control a joystick made of two circles.
# The position of the joystick is fixed if controlled by the mouse.
# It's under the finger if controlled by touch
extends Node2D

onready var big_circle = get_node("BigCircle")
onready var small_circle = get_node("SmallCircle")
onready var big_circle_radius = big_circle.texture.get_size().x / 2	
var input_ongoing : bool = false
	
func ready():
	if OS.has_touchscreen_ui_hint():
		self.visible=false
func _unhandled_input(event):
	print(event)
	if !(event.position.y < 808 || (event.position.x > 576 && event.position.x < 1456)):
		return
	if event is InputEventScreenTouch:
		if not event.pressed && input_ongoing:
				Input.action_release('shoot')
				small_circle.global_position = big_circle.global_position
				input_ongoing = false
				self.visible = false
				Vars.joyStickRotation = 0
				return
		else:
			if input_ongoing == false:
				input_ongoing = true
				self.visible = true
				var motion_vector = event.position - Vector2(1920 / 2, 1080 / 2)
				if motion_vector.length() > big_circle_radius:
					small_circle.set_position(motion_vector.normalized() * big_circle_radius)
				else:
					small_circle.set_global_position(event.position)
				self.position = event.position - small_circle.position
				var vector = small_circle.position / big_circle_radius
				Vars.joyStickRotation = vector.angle()
				Input.action_press('shoot')
				return
	if (event is InputEventScreenDrag) and input_ongoing:
		var motion_vector = event.position - position
		if motion_vector.length() > big_circle_radius:
			small_circle.set_position(motion_vector.normalized() * big_circle_radius)
		else:
			small_circle.set_global_position(event.position)

func _process(_delta):
	if input_ongoing:
		var vector = small_circle.position / big_circle_radius
		Vars.joyStickRotation = vector.angle()
		#emit_signal("move", vector*vector*vector)
