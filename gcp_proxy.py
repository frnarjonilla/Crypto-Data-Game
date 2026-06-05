import http.server
import socketserver
import urllib.request
import urllib.parse
import ssl

PORT = 8080
GCP_URL = "https://api-crypto-game-613326659452.europe-west1.run.app"

class ProxyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        print(f"\n[PROXY] ¡Godot conectado! Procesando...")
        
        # Extraemos la query de forma limpia
        parsed_url = urllib.parse.urlparse(self.path)
        query = f"?{parsed_url.query}" if parsed_url.query else ""
        
        real_url = f"{GCP_URL}{query}"
        print(f"[PROXY] Conectando a GCP: {real_url}")
        
        try:
            # 🎯 CLAVE 1: Engañamos al balanceador de Google simulando un Chrome real en Windows
            # Las cabeceras por defecto de Python a veces se descartan en Cloud Run
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                'Accept': 'application/json',
                'Cache-Control': 'no-cache',
                'Connection': 'keep-alive'
            }
            
            # 🎯 CLAVE 2: Forzamos un contexto SSL limpio por si las moscas
            ctx = ssl.create_default_context()
            ctx.check_hostname = False
            ctx.verify_mode = ssl.CERT_NONE
            
            req = urllib.request.Request(real_url, headers=headers)
            
            # Le damos un margen de 15 segundos pero con un cliente optimizado
            with urllib.request.urlopen(req, context=ctx, timeout=15) as response:
                html = response.read()
                
                # Devolvemos el botín a Godot
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.send_header("Access-Control-Allow-Origin", "*")
                self.end_headers()
                self.wfile.write(html)
                print("[PROXY] ✅ ¡Datos de BigQuery enviados a Godot con éxito!")
                
        except Exception as e:
            print(f"[PROXY ❌ ERROR] Google Cloud ha tardado demasiado o ha rechazado la llamada: {e}")
            try:
                self.send_response(500)
                self.end_headers()
                self.wfile.write(str(e).encode())
            except:
                pass

    def log_message(self, format, *args):
        pass

# Evitamos el error de "Puerto en uso" al reiniciar rápido el script
socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(("", PORT), ProxyHandler) as httpd:
    print(f"=== Servidor Puente Inteligente Activo en Puerto {PORT} ===")
    httpd.serve_forever()