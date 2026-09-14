extends Node2D

@export var player : CharacterBody2D;
@export var enemy : PackedScene;

var distance : float = randf_range(900, 1200);
var can_spawn : bool = true;

@export var enemy_type: Array[Enemy];

var minute : int:
		set(value): # pesquisat melhor sobre
			minute = value;
			%Minute.text = str(value);
			
var second : int:
		set(value): # pesquisat melhor sobre
			second = value;
			if second >= 10: #somente pra testes
				second -=10;
				minute +=1;
			%Second.text = str(second).lpad(1,"0");
			
func _physics_process(delta: float) -> void:
	if get_tree().get_node_count_in_group("Enemy") < 700:
		can_spawn = true;
	else:
		can_spawn = false;
		
func spawn(pos: Vector2):
	if not can_spawn: # and not elite
		return;
		
	var enemy_instance = enemy.instantiate();
	enemy_instance.type = enemy_type[min(minute, (enemy_type.size()+1))%enemy_type.size()];
	enemy_instance.position = pos;
	enemy_instance.player_reference = player;
	
	get_tree().current_scene.add_child(enemy_instance);

func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2*PI));
	
func amount(number: int = 1):
		for i in range(1, number):
			spawn(get_random_position());

func _on_timer_timeout() -> void:
	second += 1;
	amount(second%10); # 10 pelo fato de quando chegar a 11, o resto ser 1

func _on_pattern_timeout() -> void:
	for i in range(75):
		spawn(get_random_position());
