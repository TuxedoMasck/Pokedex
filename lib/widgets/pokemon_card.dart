import 'package:flutter/material.dart';
import '../screens/pokemon_detail.dart';
import 'type_badge.dart';

/// Widget que representa una tarjeta individual de un Pokémon en la lista principal.
class PokemonCard extends StatelessWidget {
  final Map<String, dynamic> data; // Mapa con id, name, image y types

  const PokemonCard({required this.data, super.key});

  /// Asigna un color de fondo translúcido a la tarjeta basado en el tipo del Pokémon.
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fuego': return Colors.orangeAccent.withOpacity(0.5);
      case 'agua': return Colors.blueAccent.withOpacity(0.5);
      case 'planta': return Colors.greenAccent.withOpacity(0.5);
      case 'eléctrico': return Colors.yellowAccent.withOpacity(0.5);
      case 'psíquico': return Colors.pinkAccent.withOpacity(0.5);
      case 'veneno': return Colors.purpleAccent.withOpacity(0.5);
      case 'normal': return Colors.brown.withOpacity(0.4);
      case 'bicho': return Colors.lightGreen.withOpacity(0.5);
      case 'volador': return Colors.indigo.withOpacity(0.5);
      case 'tierra': return Colors.brown.withOpacity(0.5);
      case 'roca': return Colors.grey.withOpacity(0.5);
      case 'hielo': return Colors.blue.withOpacity(0.5);
      case 'fantasma': return Colors.purple.withOpacity(0.5);
      case 'dragón': return Colors.deepPurple.withOpacity(0.5);
      case 'lucha': return Colors.orange.withOpacity(0.5);
      case 'acero': return Colors.blueGrey.withOpacity(0.5);
      case 'hada': return Colors.pink.withOpacity(0.5);
      default: return Colors.grey.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tomamos el primer tipo para el color de fondo
    final String primaryType = data["types"][0];
    final Color bgColor = _getTypeColor(primaryType);

    return GestureDetector(
      // Al tocar la tarjeta, navegamos a la pantalla de detalle
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PokemonDetailScreen(pokemon: data),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withOpacity(.05),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Carga de imagen desde red
            Image.network(data["image"], height: 80),
            const SizedBox(height: 8),
            // Nombre e ID formateado
            Text(
              "#${data['id'].toString().padLeft(3, '0')}  ${data['name']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            // Etiquetas de tipos
            Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                data["types"].length,
                (i) => TypeBadge(label: data["types"][i]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
