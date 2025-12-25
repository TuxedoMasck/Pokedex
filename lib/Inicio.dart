import 'package:flutter/material.dart';
import 'screens/pokemon_model.dart';
import 'widgets/pokemon_card.dart';

class Buscador extends StatefulWidget {
  const Buscador({super.key});

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  final TextEditingController _controller = TextEditingController();
  List<Pokemon> _pokemonFiltrados = [];

  @override
  void initState() {
    super.initState();
    _pokemonFiltrados = listaPokemon;
    // Vinculamos el controlador con la función de filtrado
    _controller.addListener(_filtrarPokemon);
  }

  void _filtrarPokemon() {
    final texto = _controller.text.toLowerCase();
    setState(() {
      _pokemonFiltrados = listaPokemon.where((pokemon) {
        final nombre = pokemon.nombre.toLowerCase();
        final id = pokemon.id.toString();
        return nombre.contains(texto) || id.contains(texto);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Buscar Pokémon por número o nombre',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _controller.clear(),
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            Expanded(
              child: _pokemonFiltrados.isEmpty 
                ? const Center(child: Text("No se encontraron Pokémon"))
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _pokemonFiltrados.length,
                    itemBuilder: (context, index) {
                      final pokemon = _pokemonFiltrados[index];
                      return PokemonCard(data: {
                        "id": pokemon.id,
                        "name": pokemon.nombre,
                        "image": (pokemon.imagen == 'https://...')
                            ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png"
                            : pokemon.imagen,
                        "types": pokemon.tipos,
                      });
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
