import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/type_badge.dart';
import '../services/pokemon_api.dart';
import '../services/favorites_provider.dart';

/// Pantalla que muestra los detalles de un Pokémon específico.
class PokemonDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pokemon; // Datos básicos del Pokémon pasados desde la lista

  const PokemonDetailScreen({required this.pokemon, super.key});

  /// Determina el color temático según el tipo de Pokémon.
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fuego': return Colors.orangeAccent;
      case 'agua': return Colors.blueAccent;
      case 'planta': return Colors.greenAccent;
      case 'eléctrico': return Colors.yellowAccent;
      case 'psíquico': return Colors.pinkAccent;
      case 'veneno': return Colors.purpleAccent;
      case 'normal': return Colors.brown.shade400;
      case 'bicho': return Colors.lightGreen;
      case 'volador': return Colors.indigo;
      case 'tierra': return Colors.brown;
      case 'roca': return Colors.grey;
      case 'hielo': return Colors.blue;
      case 'fantasma': return Colors.purple;
      case 'dragón': return Colors.deepPurple;
      case 'lucha': return Colors.orange;
      case 'acero': return Colors.blueGrey;
      case 'hada': return Colors.pink;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tomamos el primer tipo para definir el color de la interfaz
    final String primaryType = pokemon["types"][0];
    final Color typeColor = _getTypeColor(primaryType);

    // Accedemos al sistema de favoritos mediante Provider
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final bool isFav = favoritesProvider.isFavorite(pokemon['id']);

    return Scaffold(
      backgroundColor: typeColor.withOpacity(0.15), // Fondo suave del color del tipo
      appBar: AppBar(
        title: Text(pokemon["name"]),
        backgroundColor: typeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Imagen del Pokémon con un fondo circular
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Image.network(pokemon["image"], height: 160),
            ),
            const SizedBox(height: 16),
            // ID formateado (ej: #001)
            Text(
              "#${pokemon['id'].toString().padLeft(3, '0')}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Lista de tipos (Badges)
            Wrap(
              alignment: WrapAlignment.center,
              children: (pokemon["types"] as List)
                  .map((t) => TypeBadge(label: t))
                  .toList(),
            ),
            const SizedBox(height: 25),
            
            // Cargamos la descripción real desde la API usando un FutureBuilder
            FutureBuilder<Map<String, dynamic>>(
              future: PokemonApi.fetchPokemonDetails(pokemon["id"]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (snapshot.hasError) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No se pudo cargar la descripción."),
                    ),
                  );
                }

                final String description = snapshot.data?["description"] ?? "Sin descripción.";

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const Spacer(), // Empuja el botón hacia abajo
            
            // Botón para añadir/quitar de favoritos
            ElevatedButton.icon(
              onPressed: () {
                favoritesProvider.toggleFavorite(pokemon);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFav ? "Eliminado de favoritos" : "Añadido a favoritos"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isFav ? Colors.red : typeColor,
                foregroundColor: isFav ? Colors.white : Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
              label: Text(isFav ? "Quitar de favoritos" : "Añadir a favoritos"),
            )
          ],
        ),
      ),
    );
  }
}
