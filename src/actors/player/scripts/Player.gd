extends "res://src/actors/actor.gd";

onready var sprite = $Sprite;
onready var animation_tree  = $AnimationTree;
onready var animation_state = animation_tree.get("parameters/playback");
onready var raycast = $RayCast2D;

enum{
	IDLE, WALK, SHOOT
}

var state = IDLE;

func _ready():
	get_tree().call_group("enemies", "set_player", self);

func _physics_process(delta):
	_state_machine();
	_velocity = move_and_slide(_velocity);

func _state_machine() -> void:
	var delta = get_physics_process_delta_time();
	match state:
		IDLE:
			#state
			_velocity = Vector2.ZERO;
			_direction = _get_direction();
			animation_state.travel("idle");
				
			#checking for other states
			if _direction != Vector2.ZERO:
				state = WALK;
			if Input.is_action_just_pressed("attack"):
				state = SHOOT;
		WALK:
			#state
			_direction = _get_direction();
			_velocity = move(_velocity, _direction, move_speed);
			
			#checking for other states
			if _velocity == Vector2.ZERO:
				state = IDLE;
			if Input.is_action_just_pressed("attack"):
				state = SHOOT;
		SHOOT:
			#state
			_direction = _get_direction();
			var target = raycast.get_collider();
			if raycast.is_colliding() and target.has_method("kill"):
				target.kill();
			animation_state.travel("shooting");

func _get_direction() -> Vector2:
	var direction = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
							Input.get_action_strength("down") - Input.get_action_strength("up"));
	look_at(get_global_mouse_position());
	return direction;

func move(velocity: Vector2, direction: Vector2, speed) -> Vector2:
	velocity = speed * direction.normalized();
	return velocity;

func set_idle():
	state = IDLE;
	
func kill():
	get_tree().reload_current_scene();
