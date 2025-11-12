extends Node2D

# Some of this code is from an earlier version of PepperTux back in 2024.

var is_collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CoinImage.play("normal")
	$Animations.play("normal")

# Called when it's called in the script.
func collect():
	$PlayerDetection.set_deferred("monitoring", false)
	$PlayerDetection/Collision.set_deferred("disabled", true)
	Global.total_coins += 1
	$Animations.play("collect")
	$Sound.play()
	await get_tree().create_timer(1).timeout
	queue_free()

func spawn_from_block():
	is_collected = true
	$PlayerDetection.set_deferred("monitoring", false)
	$PlayerDetection/Collision.set_deferred("disabled", true)
	Global.total_coins += 1
	$Animations.play("spawn_from_block")
	$Sound.play()

# Called when Tux enters the Area2D
func _on_player_detection_body_entered(body) -> void:
	if body.is_in_group("Tux") and is_collected == false:
		is_collected = true
		collect()
