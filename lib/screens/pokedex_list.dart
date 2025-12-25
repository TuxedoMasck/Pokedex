import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/pokemon_card.dart';
import '../services/pokemon_api.dart';
import '../services/favorites_provider.dart';

/// Pantalla principal que muestra la lista de todos los Pokémon.
class PokedexListScreen extends StatefulWidget {
  const PokedexListScreen({super.key});

  @override
  State<PokedexListScreen> createState() => _PokedexListScreenState();
}

class _PokedexListScreenState extends State<PokedexListScreen> {
  // Controlador para manejar el texto del buscador
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allPokemon = []; // Lista completa descargada de la API
  List<Map<String, dynamic>> filteredPokemon = []; // Lista filtrada por búsqueda o tipo
  bool loading = true; // Estado de carga inicial

  @override
  void initState() {
    super.initState();
    loadPokemon(); // Inicia la descarga de datos

    // Escucha cambios en el buscador para filtrar en tiempo real
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredPokemon = allPokemon.where((p) {
          final name = p["name"].toLowerCase();
          final id = p["id"].toString();
          return name.contains(query) || id.contains(query);
        }).toList();
      });
    });
  }

  /// Descarga la lista de Pokémon desde el servicio API.
  Future<void> loadPokemon() async {
    try {
      final data = await PokemonApi.fetchPokemon();
      setState(() {
        allPokemon = data;
        filteredPokemon = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error cargando Pokémon")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      // Menú lateral que muestra la lista de favoritos
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Center(
                child: Text(
                  "Mis Favoritos ⭐",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: Consumer<FavoritesProvider>(
                builder: (context, provider, child) {
                  if (provider.favorites.isEmpty) {
                    return const Center(child: Text("Aún no tienes favoritos"));
                  }
                  return ListView.builder(
                    itemCount: provider.favorites.length,
                    itemBuilder: (context, index) {
                      final fav = provider.favorites[index];
                      return ListTile(
                        leading: Image.network(fav['image']),
                        title: Text(fav['name']),
                        subtitle: Text("#${fav['id']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => provider.toggleFavorite(fav),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : Column(
              children: [
                // Campo de búsqueda
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Buscar por nombre o número...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                // Cuadrícula de Pokémon
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .9,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredPokemon.length,
                    itemBuilder: (context, index) =>
                        PokemonCard(data: filteredPokemon[index]),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Limpiamos el controlador para evitar fugas de memoria
    super.dispose();
  }
}
