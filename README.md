# Pokédex Mobile App | Arquitectura y Consumo API REST

Una aplicación móvil desarrollada en Flutter que funciona como un catálogo interactivo. Este proyecto fue construido para demostrar competencias sólidas en el manejo de asincronismo, optimización de peticiones de red y gestión de estado global.

## Demostración del Proyecto
![Demo de la Pokedex](docs/pokedex_demo.mp4)

## Logros Técnicos Implementados
* **Optimización de Red:** Uso de `Future.wait` para resolver peticiones asíncronas en paralelo, reduciendo drásticamente los tiempos de carga de la *PokeAPI*.
* **Gestión de Estado Global:** Implementación del patrón `Provider` (ChangeNotifier) para manejar el sistema de "Favoritos", manteniendo la sincronización de datos en tiempo real a través de múltiples pantallas sin reconstruir toda la app.
* **Renderizado Dinámico y UI/UX:** Construcción de tarjetas que adaptan su paleta de colores dinámicamente basándose en la carga útil (payload) del JSON recibido.
* **Manejo de Estados de Carga:** Uso estratégico de `FutureBuilder` y variables de estado para presentar indicadores de carga, evitando pantallas congeladas durante el consumo de datos.

## Stack Tecnológico
* **Framework:** Flutter / Dart
* **Peticiones HTTP:** Paquete nativo `http` para comunicación con backend.
* **Arquitectura:** Separación modular (Models, Screens, Services, Widgets).

---

### 👨‍💻 Sobre el Desarrollador
Como **especialista híbrido**, aplico los principios de eficiencia, diagnóstico de fallos y optimización de recursos —fundamentales en la ingeniería de hardware— al diseño de arquitecturas de software. Este proyecto refleja mi capacidad para construir sistemas digitales fluidos, escalables y con código limpio.
