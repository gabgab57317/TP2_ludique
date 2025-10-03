extends Area2D

@export var speed: float = 150.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var is_attacking: bool = false
var is_hurt: bool = false
var is_dead: bool = false
var hurt_count: int = 0  # compteur de coups pris

func _ready() -> void:
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta: float) -> void:
	if is_dead:
		return  # plus de mouvement ni attaque si mort

	var direction := Vector2.ZERO
	
	# Déplacement
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		position += direction * speed * delta

		if direction.x < 0:
			anim.flip_h = true
		elif direction.x > 0:
			anim.flip_h = false

		if not is_attacking:
			if anim.animation != "walk_player" or not anim.is_playing():
				anim.play("walk_player")
	else:
		if not is_attacking:
			if anim.animation != "idle_player" or not anim.is_playing():
				anim.play("idle_player")
	
	# Attaques
	if not is_hurt and not is_dead:
		if Input.is_action_just_pressed("attack1"):
			anim.play("attack1_player")
			is_attacking = true
		elif Input.is_action_just_pressed("attack2"):
			anim.play("attack2_player")
			is_attacking = true

func _on_area_entered(area: Area2D) -> void:
	if is_dead: 
		return
	if area.has_meta("enemy_attack") and area.get_meta("enemy_attack") == true:
		var enemy_anim: AnimatedSprite2D = area.get_parent().get_node("AnimatedSprite2D")
		if enemy_anim.animation.begins_with("attack") and enemy_anim.is_playing():
			_take_damage()

func _take_damage() -> void:
	if is_hurt or is_dead:
		return
	
	if hurt_count >= 5:
		_force_death()
		return
	
	is_hurt = true
	hurt_count += 1
	anim.play("hurt_player")

func _force_death() -> void:
	if is_dead:
		return
	is_dead = true
	anim.play("death_player")

func _on_animation_finished() -> void:
	if is_dead:
		# Mort terminée → attendre 5s puis relancer la scène
		get_tree().reload_current_scene()
		return

	# Fin d’attaque
	if anim.animation in ["attack1_player", "attack2_player"]:
		is_attacking = false
		anim.play("idle_player")
	
	# Fin de hurt
	elif anim.animation == "hurt_player":
		is_hurt = false
		if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			anim.play("idle_player")
