extends Camera2D

var picked = false

const ZOOM_OUT_MAX = 0.8
const ZOOM_IN_MAX = 2.4
const ZOOM_SPEED = 0.25

func _ready():
	enabled = true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 3:
			if event.pressed:
				#print(self.name + " is Picked")
				picked = true
			else:
				#print(self.name + " is not Picked")
				picked = false
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# zoom
			var ratio = minf(ZOOM_IN_MAX, zoom.lerp(zoom*1.5,ZOOM_SPEED).x)
			zoom = Vector2(ratio, ratio)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# zoom out
			var ratio = maxf(ZOOM_OUT_MAX, zoom.lerp(zoom*0.75,ZOOM_SPEED).y)
			zoom = Vector2(ratio, ratio)
	
	
	if event is InputEventMouseMotion and picked:
		var fPosition = global_position - event.relative / zoom.x
		position = Vector2(clampf(fPosition.x,limit_left+(get_viewport_rect().size.x/2)/zoom.x,limit_right-(get_viewport_rect().size.x/2)/zoom.x), clampf(fPosition.y,limit_top+(get_viewport_rect().size.y/2)/zoom.x,limit_bottom-(get_viewport_rect().size.y/2)/zoom.x))

func check_pos(fPosition: Vector2):
	var checkX = fPosition.x - (get_viewport_rect().size.x/2) >= limit_left and fPosition.x + (get_viewport_rect().size.x/2) <= limit_right
	var checkY = fPosition.y - (get_viewport_rect().size.y/2) >= limit_top and fPosition.y + (get_viewport_rect().size.y/2) <= limit_bottom
	return checkX and checkY
