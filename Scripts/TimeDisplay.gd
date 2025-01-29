extends Label

var time = 0

func _ready():
	text = format_time(time)

func format_time(seconds: int):
	var minutes = int((seconds % 3600) / 60)
	var secs = seconds % 60
	return str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)

func _on_timer_timeout():
	time += 1
	text = format_time(time)
