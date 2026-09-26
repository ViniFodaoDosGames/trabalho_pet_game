extends CharacterBody2D

@export var player_reference : CharacterBody2D
var damage_popup_node = preload("res://scenes/damage_popup.tscn")


var direction : Vector2
var speed : float = 75
var damage: float
var knockback : Vector2
var separation : float

var health: float:
	set(value):
		health = value
		if health <= 0:
			queue_free()

var elite: bool = false:
	set(value):
		elite = value
		if value:
			%Sprite.material = load("uid://cne0m6odkiag2")
			scale = Vector2(1.5, 1.5)
			damage = damage * 1.5
			health = health * 1.5

var type: Enemy: 
	set(value):
		type = value
		%Sprite.texture = type.texture
		damage = value.damage
		health = value.health

func _physics_process(delta: float) -> void:
	knockback_update(delta)
	check_separation(delta)

func take_damage(damage_taken: float):
	health -= damage_taken
	damage_popup(damage_taken)
	

func damage_popup(amount):
	var popup = damage_popup_node.instantiate()
	popup.text = str(amount)
	popup.position = position + Vector2(-50, -25)
	get_tree().current_scene.add_child(popup)
	

func check_separation(_delta: float) -> void:
	separation = (player_reference.position - position).length()
	if separation >= 2300 and not elite:
		queue_free()
		
	if separation < player_reference.nearest_enemy_distance:
		player_reference.nearest_enemy = self
		player_reference.nearest_enemy_distance = separation

func knockback_update(delta: float) -> void:
	velocity = (player_reference.position - position).normalized() * speed 
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback

	var colider = move_and_collide(velocity*delta)
	if colider:
		colider.get_collider().knockback = (colider.get_collider().global_position - global_position).normalized() * 100
