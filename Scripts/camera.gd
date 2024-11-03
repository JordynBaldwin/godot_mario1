extends Camera2D



func _ready():
	Global.camera = self

func updateLimits(leftLimit, topLimit, rightLimit, bottomLimit):
	limit_left = leftLimit
	limit_top = topLimit
	limit_right = rightLimit
	limit_bottom = bottomLimit
