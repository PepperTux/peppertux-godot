extends StaticBody2D

# Some code is from an old PepperTux, updated to show the coin. 

enum bonus_block_content {Coin, Egg, FireFlower, IceFlower, AirFlower, Star, TuxDoll}

@export var content: bonus_block_content

# TODO: Add power-ups when they get added
const coin = preload("res://scenes_and_scripts/objects/coin_from_block.tscn")

func _ready() -> void:
	$Image.play("full")

func _on_player_detection_body_entered(body) -> void:
	if body.is_in_group("Tux"):
		spawn_object()

func spawn_object():
	var position_of_powerup = self.position + Vector2(0, -32)
	$BrickSound.play()
	$AnimationPlayer.play("hit")
	$PlayerDetection.set_deferred("monitoring", false)
	$PlayerDetection/CollisionShape2D.set_deferred("disabled", true)
	
	if content == bonus_block_content.Coin:
		var c = coin.instantiate()
		c.position = position_of_powerup
		get_tree().current_scene.call_deferred("add_child", c)
		c.call_deferred("spawn_from_block")

func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "hit":
		$Image.play("empty")
