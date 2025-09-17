import 'package:flutter/material.dart';
import 'productos_servicee.dart';

class BuscarProductoPage extends StatefulWidget {
  const BuscarProductoPage({super.key});

  @override
  State<BuscarProductoPage> createState() => _BuscarProductoPageState();
}

class _BuscarProductoPageState extends State<BuscarProductoPage> {
  final TextEditingController _controller = TextEditingController();
  final ProductosService _service = ProductosService();

  Map<String, dynamic>? _producto;
  String _mensaje = "";
  bool _cargando = false;

  void _buscarProducto() async {
    setState(() {
      _cargando = true;
      _mensaje = "";
      _producto = null;
    });

    final nombre = _controller.text.trim();
    if (nombre.isEmpty) {
      setState(() {
        _mensaje = "Por favor ingresa un nombre de producto";
        _cargando = false;
      });
      return;
    }

    try {
      final productos = await _service.listarProductos();
      final encontrado = productos.firstWhere(
        (p) => p["nombre"].toString().toLowerCase() == nombre.toLowerCase(),
        orElse: () => null,
      );

      setState(() {
        if (encontrado != null) {
          _producto = encontrado;
        } else {
          _mensaje = "Producto no encontrado";
        }
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _mensaje = "Error: ${e.toString()}";
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Nombre del producto",
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarProducto,
              child: const Text("Buscar"),
            ),
            const SizedBox(height: 20),
            if (_cargando) const CircularProgressIndicator(),
            if (_mensaje.isNotEmpty) Text(_mensaje),
            if (_producto != null)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ListTile(
                  title: Text(_producto!["nombre"]),
                  subtitle: Text(
                      "${_producto!["descripcion"]}\nPrecio: \$${_producto!["precio"]} - Categoría: ${_producto!["categoria"]}"),
                  isThreeLine: true,
                ),
              )
          ],
        ),
      ),
    );
  }
}
