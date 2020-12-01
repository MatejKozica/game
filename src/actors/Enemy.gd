extends KinematicBody2D

var player = null;

func kill():
	queue_free();

func _ready():
	add_to_group("enemies");

func _physics_process(delta):
	if player == null:
		return
	
	look_at(player.global_position);

func set_player(p):
	player = p;
