extends "res://src/actors/actor.gd"

var player = null;

func _ready():
	add_to_group("enemies");

func _physics_process(delta):
	if player == null:
		return
	
	var movement : Vector2 = player.global_position - global_position;
	move_and_slide(movement);
	look_at(player.global_position);

func set_player(p):
	player = p;

func kill():
	queue_free();
