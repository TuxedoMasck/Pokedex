import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/pokedex_list.dart';
import 'services/favorites_provider.dart';

/// Punto de entrada principal de la aplicación.
void main() {
  runApp(
    // Envolvemos la app en un ChangeNotifierProvider para gestionar el estado de los favoritos
    // de forma global en toda la aplicación.
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: const MyApp(),
    ),
  );
}

/// Widget raíz que configura el diseño global y la navegación inicial.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la banda de "Debug"
      title: 'Pokedex',
      theme: ThemeData(
        useMaterial3: true, // Usa el diseño Material 3 de Google
        colorSchemeSeed: Colors.red, // Genera un tema basado en el color rojo
      ),
      // Definimos la pantalla de inicio como la lista de Pokémon
      home: const PokedexListScreen(),
    );
  }
}
