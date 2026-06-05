extends Area2D

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var crypto_text: RichTextLabel = $CryptoText
@onready var texto_timer: Timer = $TextoTimer
@onready var nombre_moneda: Label = $NombreMoneda

const API_URL = "https://api-crypto-lectura-613326659452.europe-southwest1.run.app/"

# 🎯 LA CLAVE: Esta variable aparecerá en tu panel de la derecha (Inspector)
# Ponemos "BTC" por defecto, pero se podrá cambiar en cada terminal
@export var moneda_a_cargar: String = "BTC"

var jugador_cerca: bool = false

func _ready():
	http_request.request_completed.connect(_on_request_completed)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	texto_timer.timeout.connect(_on_texto_timer_timeout)
	crypto_text.text = "" 
	
	# Toma el valor de la variable exportada (BTC, ETH, SOL) y lo pone en mayúsculas como título fijo
	nombre_moneda.text = moneda_a_cargar.to_upper()

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("ui_accept"):
		texto_timer.stop() 
		crypto_text.visible_characters = -1
		
		crypto_text.text = "Cargando datos de BigQuery..."
		# 🎯 Cambiamos el "BTC" fijo por nuestra variable exportada
		solicitar_precio_crypto(moneda_a_cargar)

func solicitar_precio_crypto(moneda: String):
	var url_completa = API_URL + "?coin=" + moneda.to_upper()
	print("🚀 Consultando desde la terminal: ", url_completa)
	http_request.request(url_completa)

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var json = JSON.new()
		var parse_err = json.parse(body.get_string_from_utf8())
		
		if parse_err == OK:
			var data = json.get_data()
			var asset = data["asset"]
			var price = data["price"]
			var var_1h = float(data["var_1h"]) # Lo forzamos a número para calcular la flecha
			
			# 1. Calculamos la flecha y el color dinámico según la variación
			var flecha: String = ""
			var color_var: String = ""
			
			if var_1h > 0:
				flecha = "▲"
				color_var = "#00ff00" # Verde brillante si sube
			elif var_1h < 0:
				flecha = "▼"
				color_var = "#ff0000" # Rojo brillante si baja
			else:
				flecha = "◀▶"
				color_var = "#ffffff" # Blanco si está plano

			# 2. Capturamos la hora actual del sistema para el "Last update"
			# 1. Leemos la clave de la base de datos
			var fecha_original: String = str(data.get("updated", "No disponible"))
			var fecha_real: String = ""
			
			if fecha_original != "No disponible" and fecha_original.length() >= 16:
				# Limpiamos si viene con la "T" de formato ISO (ej: 2026-06-04T10:25:00Z)
				var fecha_limpia = fecha_original.replace("T", " ")
				
				# Separamos los bloques principales por el espacio: ["2026-06-04", "10:25:00..."]
				var partes = fecha_limpia.split(" ")
				var componente_fecha = partes[0] # "2026-06-04"
				var componente_hora = partes[1]  # "10:25:00"
				
				# Extraemos Día y Mes separando por el guion: ["2026", "06", "04"]
				var trozos_fecha = componente_fecha.split("-")
				var mes = trozos_fecha[1]
				var dia = trozos_fecha[2]
				
				# Extraemos Hora y Minuto separando por los dos puntos: ["10", "25", "00"]
				var trozos_hora = componente_hora.split(":")
				var hora = trozos_hora[0]
				var minuto = trozos_hora[1]
				
				# 🎯 CONSTRUIMOS EL FORMATO: Día/Mes Hora:Minuto
				fecha_real = dia + "/" + mes + " " + hora + ":" + minuto
			else:
				fecha_real = fecha_original

			# 3. Construimos el diseño visual atractivo usando BBCode
			# [b] = Negrita, [color=HEX] = Cambiar color de esa palabra, \n = Salto de línea
			crypto_text.text = (
				"[b]" + str(asset).to_upper() + "[/b]\n" +
				"Current value: [b]$" + str(price) + "[/b]\n" +
				"Previous difference: [color=" + color_var + "]" + flecha + " " + str(var_1h) + "[/color]\n" +
				"Last update: [i]" + fecha_real + "[/i]"
			)
			crypto_text.visible_characters = 0 
			texto_timer.start()
			
			$icono_btc.visible = true

# 🚶 Cuando el jugador entra en la zona de la terminal
func _on_body_entered(body):
	# Si tu personaje se llama "Player" o tiene ese script asignado
	if "player" in body.name.to_lower(): 
		jugador_cerca = true
		texto_timer.stop()
		crypto_text.text = "[Presiona ESPACIO para usar terminal]"

# 🏃 Cuando el jugador se aleja de la terminal
func _on_body_exited(body):
	if "player" in body.name.to_lower():
		jugador_cerca = false
		texto_timer.stop()
		crypto_text.text = "" # Borramos el texto al alejarse
		$icono_btc.visible = true

func _on_texto_timer_timeout():
	if crypto_text.visible_characters < crypto_text.get_total_character_count():
		crypto_text.visible_characters += 1
	else:
		texto_timer.stop()
