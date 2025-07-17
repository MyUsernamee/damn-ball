extends Node 

@onready var ball: Ball = $/root/Game/Ball;
@onready var right_hoop: Node3D = $/root/Game/Hoops/RightHoop;
@onready var left_hoop: Node3D = $/root/Game/Hoops/LeftHoop;

func get_hoop(which):
	return right_hoop if which else right_hoop

