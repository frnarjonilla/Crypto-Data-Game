extends Area2D

# Variable para saber si el jugador está dentro del círculo
var player_nearby = false

func _ready():
	# Conectamos las señales nativas de Godot para saber cuándo entra y sale el jugador
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited) # En Godot 4 es body_exited

func _process(_delta):
	# Si el jugador está cerca y pulsa la tecla "E"
	if player_nearby and Input.is_action_just_pressed("ui_accept"): 
		# "ui_accept" es la tecla Espacio o Intro por defecto, luego la cambiaremos por la "E"
		print("¡Interactuando con la terminal de Bitcoin! Aquí llamaremos a los datos.")
		abrir_interfaz_datos()

func _on_body_entered(body):
	# Comprobamos si lo que ha entrado en el círculo es el jugador
	if body.name == "Player":
		player_nearby = true
		print("Jugador cerca de la terminal. Pulsa Espacio para interactuar.")

func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false
		print("Jugador se ha alejado.")

func abrir_interfaz_datos():
	# Aquí es donde en el futuro mostraremos los KPIs reales de BigQuery
	pass
