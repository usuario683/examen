import 'package:flutter/material.dart';
import 'productos_page.dart';
import 'buscar_producto_page.dart';

class HomePage extends StatelessWidget {
  final String nombres;
  final String apellidos;

  const HomePage({
    super.key,
    required this.nombres,
    required this.apellidos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bienvenido $nombres $apellidos",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 40),

            // Botón para ver productos
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text("Ver Productos"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductosPage()),
                );
              },
            ),
            const SizedBox(height: 20),

            // Botón para buscar productos (aquí también puedes registrar si no existe)
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text("Buscar / Registrar Producto"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BuscarProductoPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
