extends CharacterBody2D

# States
enum States {Small, Big, Fire, Ice, Air}
var current_state = States.Small

# Invincibility Frames + Invincibility
var invincible = false
var can_take_damage = true
