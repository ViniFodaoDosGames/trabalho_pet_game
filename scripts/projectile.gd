extends Area2D

var direction: Vector2 = Vector2.RIGHT:
	set(value):
		direction = value
		look_at(position + direction)
var speed: float = 200
var damage: float = 1

func _physics_process(delta: float) -> void:
	position +=direction*speed*delta

func set_sprite(texture: Texture2D):
	
	%Sprite.texture = texture
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		return
	
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
