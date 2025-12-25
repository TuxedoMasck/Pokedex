import 'dart:convert';
import 'package:http/http.dart' as http;

/// Clase de servicio que gestiona todas las llamadas a la PokeAPI.
class PokemonApi {
  /// Obtiene la lista de los primeros 151 Pokémon con sus detalles básicos (ID, Nombre, Imagen, Tipos).
  static Future<List<Map<String, dynamic>>> fetchPokemon() async {
    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=151");
    final res = await http.get(url);

    if (res.statusCode != 200) throw Exception("Error cargando Pokémon");

    final data = json.decode(res.body);
    final List results = data["results"];

    // Creamos una lista de futuros para descargar los detalles de cada Pokémon en paralelo.
    final detailFutures = results.map((item) async {
      final detailRes = await http.get(Uri.parse(item["url"]));
      if (detailRes.statusCode == 200) {
        final detailData = json.decode(detailRes.body);
        final List types = detailData["types"];

        // Diccionario para traducir los tipos de inglés a español.
        final Map<String, String> typeTranslation = {
          "fire": "Fuego", "water": "Agua", "grass": "Planta",
          "electric": "Eléctrico", "psychic": "Psíquico", "poison": "Veneno",
          "normal": "Normal", "bug": "Bicho", "flying": "Volador",
          "ground": "Tierra", "rock": "Roca", "ice": "Hielo",
          "ghost": "Fantasma", "dragon": "Dragón", "fighting": "Lucha",
          "steel": "Acero", "fairy": "Hada"
        };

        return {
          "id": detailData["id"],
          "name": capitalize(detailData["name"]),
          "image": detailData["sprites"]["front_default"] ?? "",
          "types": types.map((t) {
            String engName = t["type"]["name"];
            return typeTranslation[engName] ?? capitalize(engName);
          }).toList(),
        };
      }
      return <String, dynamic>{};
    }).toList();

    // Esperamos a que todas las peticiones asíncronas terminen antes de continuar.
    final List<Map<String, dynamic>> finalResults = await Future.wait(detailFutures);

    // Agregamos a Mudkip manualmente al final de la lista por capricho
    finalResults.add({
      "id": 258,
      "name": "Mudkip",
      "image": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/258.png",
      "types": ["Agua", "Tierra"],
    });

    finalResults.add({
      "id": 0792,
      "name": "Lunala",
      "image": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/792.png",
      "types": ["Hielo", "Fantasma"],
    });
    return finalResults;
  }

  /// Devuelve una lista de tipos estáticos para el sistema de filtrado.
  static Future<List<String>> fetchAllTypes() async {
    return ["Todos", "Fuego", "Agua", "Planta", "Eléctrico", "Psíquico", "Veneno", "Bicho", "Normal"];
  }

  /// Obtiene la descripción detallada de un Pokémon desde el endpoint de especies.
  static Future<Map<String, dynamic>> fetchPokemonDetails(int id) async {
    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon-species/$id/");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List texts = data["flavor_text_entries"];
      
      // Intentamos encontrar el texto en español, si no, lo buscamos en inglés.
      final descriptionEntry = texts.firstWhere(
            (entry) => entry["language"]["name"] == "es",
        orElse: () => texts.firstWhere(
              (entry) => entry["language"]["name"] == "en",
          orElse: () => {"flavor_text": "No hay descripción disponible."},
        ),
      );

      // Limpiamos caracteres de control (\n, \f) para un formato de texto limpio.
      return {
        "description": descriptionEntry["flavor_text"].replaceAll('\n', ' ').replaceAll('\f', ' '),
      };
    }
    throw Exception("No se pudo cargar el detalle");
  }

  /// Convierte la primera letra de un texto en mayúscula
  static String capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
