extends CharacterBody2D;
class_name PlayerController;

@export var mov_speed = 170.0
@export var sprint_increase = 1.5

var direction: Vector2;
var sprint = false;
var sprint_multiplier = 1.0;
var health : float = 100:
	set(value):
		health = value;
		%Health.value = value;

var nearest_enemy : CharacterBody2D;
var nearest_enemy_distance : float = INF;


func _physics_process(delta: float) -> void:
	
	if nearest_enemy:
		nearest_enemy_distance = nearest_enemy.separation;
		print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF; 
	
	velocity = Input.get_vector("moves_left","moves_right","moves_up","moves_down").normalized() *mov_speed;
	move_and_collide(velocity*delta);

func take_damage(amount):
	health -=amount;
	print(amount);
	
func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage);


func _on_timer_timeout() -> void:
	%HurtBox.set_deferred("disabled", true);
	%HurtBox.set_deferred("disabled", false);
