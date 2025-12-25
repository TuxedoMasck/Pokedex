import 'package:flutter/material.dart';

/// Clase encargada de gestionar el estado de los favoritos usando el patrón Provider.
/// Al extender de 'ChangeNotifier', permite notificar a los widgets cuando la lista cambia.
class FavoritesProvider extends ChangeNotifier {
  // Lista interna privada de Pokémon favoritos
  final List<Map<String, dynamic>> _favorites = [];

  // Getter para acceder a la lista desde fuera de la clase
  List<Map<String, dynamic>> get favorites => _favorites;

  /// Añade o elimina un Pokémon de la lista de favoritos.
  void toggleFavorite(Map<String, dynamic> pokemon) {
    // Verificamos si el Pokémon ya está en la lista comparando sus IDs
    final isExist = _favorites.any((p) => p['id'] == pokemon['id']);
    
    if (isExist) {
      // Si ya existe, lo eliminamos
      _favorites.removeWhere((p) => p['id'] == pokemon['id']);
    } else {
      // Si no existe, lo añadimos
      _favorites.add(pokemon);
    }
    
    // Notificamos a todos los widgets que estén escuchando (Consumer) para que se redibujen
    notifyListeners();
  }

  /// Comprueba si un Pokémon específico es favorito mediante su ID.
  bool isFavorite(int id) {
    return _favorites.any((p) => p['id'] == id);
  }
}
