extends CharacterBody2D

@export var player_reference : CharacterBody2D
var direction : Vector2
var speed : float = 75
var damage: float;
var knockback : Vector2;
var separation : float;

var type: Enemy: 
	set(value):
		type = value;
		%Sprite2D.texture = type.texture;
		damage = value.damage;

func _physics_process(delta: float) -> void:
	knockback_update(delta);
	cheack_separation(delta);
	
func cheack_separation(delta: float) -> void:
	separation = (player_reference.position - position).length();
	if separation >= 2300: # and not elite:
		queue_free();
		
	if separation < player_reference.nearest_enemy_distance:
		player_reference.nearest_enemy = self;

func knockback_update(delta: float) -> void: #função diferente, função separada
	velocity = (player_reference.position - position).normalized() * speed; ##movimentar em diração ao jogador
	knockback = knockback.move_toward(Vector2.ZERO, 1);
	velocity += knockback;
	
	var colider = move_and_collide(velocity*delta)
	if colider:
		colider.get_collider().knockback = (colider.get_collider().global_position - global_position).normalized() * 100;
