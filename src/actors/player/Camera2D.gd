extends Camera2D

var shake_strength = 2.0
var shake_t = 0.0

var shake_enabled = true

func _process(delta) -> void:
	if shake_enabled:
		if shake_t > 0.0:
			shake_t -= delta
			if shake_t <= 0.0:
				offset = Vector2.ZERO
			else:
				offset = Vector2(rand_range(-shake_strength, shake_strength), rand_range(-shake_strength, shake_strength))
				

func shake(duration: float, strength: float) -> void:
	if not shake_enabled: return
	
	shake_t = duration
	shake_strength = strength

