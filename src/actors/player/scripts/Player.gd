extends "res://src/actors/actor.gd";

onready var sprite = $Sprite;
onready var animation_tree = $AnimationTree;
onready var animation_state = animation_tree.get("parameters/playback");

enum{
	IDLE, WALK, ATTACK
}

var state = IDLE;

func _ready():
	animation_tree.active = true;

func _physics_process(delta):
	_state_machine();
	_velocity = move_and_slide(_velocity);

func _state_machine() -> void:
	var delta = get_physics_process_delta_time();
	match state:
		IDLE:
			#state
			_velocity.x = 0; 
			_direction = _get_direction();
			animation_state.travel("idle");
			
			#checking for other states
			if _direction != Vector2.ZERO:
				state = WALK;
			if Input.is_action_just_pressed("attack"):
				state = ATTACK;
				print("udri");
		WALK:
			#state
			_direction = _get_direction();
			_velocity = move(_velocity, _direction, move_speed);
			animation_state.travel("walk");
			
			#checking for other states
			if _velocity == Vector2.ZERO:
				state = IDLE;
			if Input.is_action_just_pressed("attack"):
				state = ATTACK;
				print("udri");
		ATTACK:
			#state
#			_direction = _get_direction();
			animation_state.travel("attack_sword");
			
			#checking for other states
			

func _get_direction() -> Vector2:
	var direction = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
							Input.get_action_strength("down") - Input.get_action_strength("up"));
	animation_tree.set("parameters/walk/blend_position", _direction);
	animation_tree.set("parameters/idle/blend_position", _direction);
	animation_tree.set("parameters/attack_sword/blend_position", _direction);
	return direction;

func move(velocity: Vector2, direction: Vector2, speed) -> Vector2:
	velocity = speed * direction.normalized();
	return velocity;
	
func setIdle() -> void:
	state = IDLE;
