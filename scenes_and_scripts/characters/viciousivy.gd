extends CharacterBody2D

# From an older PepperTux, but edited.

# Movement
var speed = 80
var direction = -1

# Fireball Death
var fireball_death_jump = -200
var fireball_death_velocity = -100

# Squished
var squishtime = 2

func _ready() -> void:
	add_to_group("Enemy")
	$Image.play("walk")

func _physics_process(delta: float) -> void:
	velocity += get_gravity() / 2 * delta
	velocity.x = speed * direction

	if $WallDetection.is_colliding():
		flip()

	move_and_slide()
	
func flip():
	speed *= -1
	direction *= 1
	$Image.flip_h = !$Image.flip_h
	$WallDetection.target_position.x *= -1

func squished():
	speed = 0
	$Image.play("squished")
	$SquishSound.play()
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(squishtime).timeout
	queue_free()

func firedeath():
	speed = fireball_death_velocity
	$FallSound.play()
	velocity.y += fireball_death_jump
	$Image.flip_v = true
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$Collision.set_deferred("disabled", true)

func _on_hitbox_body_entered(body) -> void:
	var thing = body.global_position.y - global_position.y # I forgot what this does.
	if body.is_in_group("Tux"):
		if thing < -10:
			squished()
			if Input.is_action_pressed("player_jump"):
				body.velocity.y = -576
			else:
				body.velocity.y = -256
		else:
			body.queue_free()
 
	if body.is_in_group("FireBullet"):
		firedeath()
		body.queue_free()
