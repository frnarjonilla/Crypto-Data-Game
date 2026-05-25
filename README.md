# 👾 Crypto Data RPG - Gamificando la Ingeniería de Datos

Este proyecto es el front-end interactivo y gamificado del pipeline de datos en tiempo real de criptomonedas. En lugar de utilizar un dashboard tradicional, los usuarios controlan un avatar en un entorno 2D (desarrollado en **Godot Engine 4**) para explorar e interactuar con los KPIs del mercado directamente desde una "ciudad de datos".

El juego se conecta de forma serverless a una API en GCP que consume los datos modelados en **Google BigQuery** mediante **dbt**.

---

## 🏗️ Arquitectura de la Solución (End-to-End)

1. **Ecosistema de Datos (Back-end):** [Enlace a tu otro repositorio de GCP] (Cloud Functions + dbt + BigQuery).
2. **Capa de Abstracción (API):** Una Cloud Function HTTP actúa como pasarela segura, recibiendo las peticiones del juego y abstrayendo las credenciales de BigQuery.
3. **Cliente del Juego (Front-end):** Desarrollado en GDScript (Godot), exportado a HTML5 y alojado de forma gratuita en GitHub Pages / Itch.io.

---

## 🎮 Características del Juego

* **Movimiento Top-Down 2D:** Control de personaje fluido mediante físicas nativas (`CharacterBody2D`).
* **Zonas de Interacción Dinámicas:** Uso de señales (`Area2D`) para detectar la proximidad del jugador a las terminales financieras.
* **Consumo de APIs en Tiempo Real:** (En desarrollo) Conexión asíncrona mediante el nodo `HTTPRequest` de Godot para actualizar la UI del juego con datos reales de BigQuery.

---

## 🛠️ Stack Tecnológico

* **Motor de Juego:** Godot Engine 4 (GDScript / Python-like syntax).
* **Despliegue Web:** HTML5 / WebGL export.
* **Alojamiento:** GitHub Pages.
