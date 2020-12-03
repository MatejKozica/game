extends "res://src/actors/actor.gd";

onready var raycast = $shooting_raycast;
onready var fireEffect = $fireEffect;
onready var camera = $Camera2D;

const AMMO_MAX = 6
var ammo = AMMO_MAX

func _ready():
	get_tree().call_group("enemies", "set_player", self)

func _process(delta):
	_direction = _get_direction()
	if _direction != Vector2.ZERO:
		_velocity  = move(_velocity, _direction, move_speed)
		_velocity = move_and_slide(_velocity);
		_velocity = Vector2.ZERO

	
func _unhandled_input(event):
	if Input.is_action_just_pressed("attack") and ammo > 0:
		fire()
		
	if Input.is_action_just_pressed("reload"):
		ammo = AMMO_MAX


func _get_direction() -> Vector2:
	var direction = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
							Input.get_action_strength("down") - Input.get_action_strength("up"))
	look_at(get_global_mouse_position())
	return direction

func move(velocity: Vector2, direction: Vector2, speed: float) -> Vector2:
	velocity = speed * direction.normalized()
	return velocity
	
func kill() -> void:
	get_tree().reload_current_scene()

func fire() -> void:
	var target = raycast.get_collider()
	
	if raycast.is_colliding() and target.has_method("kill"):
		target.kill();
	
	camera.shake(0.2, 2)
	fireEffect.emitting = true
	ammo -= 1
