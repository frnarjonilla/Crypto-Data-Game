extends CharacterBody2D

# Velocidad a la que se moverá el personaje (en píxeles por segundo)
const SPEED = 300.0

func _physics_process(_delta):
	# Inicializamos la dirección del movimiento en cada frame (X, Y)
	var direction = Vector2.ZERO
	
	# Detectamos las teclas de dirección o flechas (mapeadas por defecto en Godot)
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	# Si se está pulsando alguna tecla, normalizamos el vector para que no camine más rápido en diagonal
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	# Asignamos la velocidad final basada en la dirección
	velocity = direction * SPEED

	# move_and_slide es una función nativa que mueve el cuerpo y gestiona las colisiones automáticamente
	move_and_slide()
