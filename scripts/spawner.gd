extends Node2D

@export var player : PlayerController
@export var enemy : PackedScene

var distance : float = randf_range(900, 1200)
var can_spawn : bool = true

@export var enemy_type: Array[Enemy]

var minute : int:
		set(value):
			minute = value
			%Minute.text = str(value)
			
var second : int:
		set(value):
			second = value
			if second >= 60:
				second -= 60
				minute +=1
			%Second.text = str(second).lpad(1,"0")
			

func _ready():
	player.player_morreu.connect(game_over)

func game_over():
	%TelaGameOver.show()
	#player.process_mode = Node.PROCESS_MODE_DISABLED
	#player.set_process(false)
	player.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)

func _physics_process(_delta: float) -> void:
	if get_tree().get_node_count_in_group("Enemy") < 700:
		can_spawn = true
	else:
		can_spawn = false
		
func spawn(pos: Vector2, elite: bool = false):
	
	if not can_spawn and not elite:
		return
		
	
	# criamos o inimigo
	var enemy_instance = enemy.instantiate()
	
	# ajustamos posição, dentre outros dados...
	enemy_instance.type = enemy_type[min(minute, (enemy_type.size()+1)) % enemy_type.size()]
	enemy_instance.position = pos
	enemy_instance.player_reference = player
	enemy_instance.elite = elite
	
	%EnemyHolder.add_child(enemy_instance)

func get_random_position() -> Vector2:
	
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2*PI))
	

func amount(number: int = 1):
		for i in range(1, number):
			spawn(get_random_position())

func _on_timer_timeout() -> void:
	second += 1
	amount(second%10)

func _on_pattern_timeout() -> void:
	for i in range(75):
		spawn(get_random_position())

func _on_elite_timeout():
	spawn(get_random_position(), true)
