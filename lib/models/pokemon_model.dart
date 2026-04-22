/// Clase que define la estructura de datos de un Pokémon.
class Pokemon {
  final int id; // ID único (ej: 1 para Bulbasaur)
  final String nombre; // Nombre del Pokémon
  final String imagen; // URL de la imagen del Pokémon
  final List<String> tipos; // Lista de tipos (ej: ['Planta', 'Veneno'])

  Pokemon({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.tipos,
  });
}

/// Lista estática de Pokémon utilizada para pruebas locales 
/// (antes de conectar la API).
final List<Pokemon> listaPokemon = [
  Pokemon(id: 1, nombre: 'Bulbasaur', imagen: 'https://...', tipos: ['Planta', 'Veneno']),
  Pokemon(id: 4, nombre: 'Charmander', imagen: 'https://...', tipos: ['Fuego']),
  Pokemon(id: 7, nombre: 'Squirtle', imagen: 'https://...', tipos: ['Agua']),
  Pokemon(id: 25, nombre: 'Pikachu', imagen: 'https://...', tipos: ['Eléctrico']),
  Pokemon(id: 151, nombre: 'Mew', imagen: 'https://...', tipos: ['Psíquico']),
  Pokemon(id: 258, nombre: 'Mudkip', imagen: 'https://...', tipos: ['Agua', 'Tierra']),
];
