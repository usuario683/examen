import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  List<dynamic> _productos = [];
  List<dynamic> _productosFiltrados = [];
  bool _cargando = true;
  String _error = "";

  final TextEditingController _busquedaCtrl = TextEditingController();

  // controladores para registrar producto nuevo
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _descripcionCtrl = TextEditingController();
  final TextEditingController _precioCtrl = TextEditingController();
  final TextEditingController _categoriaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final url = Uri.parse(
          "http://192.168.18.7/APIJAPON_V1-main/APIAPPJAPON/productos.php");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _productos = jsonDecode(response.body);
          _productosFiltrados = _productos;
          _cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  void _filtrarProductos(String query) {
    setState(() {
      _productosFiltrados = _productos
          .where((p) =>
              p["nombre"].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _registrarProducto() async {
    final url = Uri.parse(
        "http://192.168.18.7/APIJAPON_V1-main/APIAPPJAPON/productos.php");

    final response = await http.post(
      url,
      body: {
        "nombre": _nombreCtrl.text,
        "descripcion": _descripcionCtrl.text,
        "precio": _precioCtrl.text,
        "idCategoria": _categoriaCtrl.text,
      },
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Producto agregado")),
      );

      _nombreCtrl.clear();
      _descripcionCtrl.clear();
      _precioCtrl.clear();
      _categoriaCtrl.clear();

      _cargarProductos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${data['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar y Registrar Productos")),
      body: Column(
        children: [
          // 🔍 buscador
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _busquedaCtrl,
              onChanged: (value) {
                _filtrarProductos(value);
              },
              decoration: const InputDecoration(
                hintText: "Buscar producto...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 📝 formulario SOLO aparece si no hay resultados en la búsqueda
          if (_productosFiltrados.isEmpty && _busquedaCtrl.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text("Producto no encontrado, agrega uno nuevo:",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _nombreCtrl..text = _busquedaCtrl.text,
                    decoration: const InputDecoration(labelText: "Nombre"),
                  ),
                  TextField(
                    controller: _descripcionCtrl,
                    decoration: const InputDecoration(labelText: "Descripción"),
                  ),
                  TextField(
                    controller: _precioCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Precio"),
                  ),
                  TextField(
                    controller: _categoriaCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "ID Categoría"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _registrarProducto,
                    child: const Text("Registrar Producto"),
                  ),
                ],
              ),
            ),

          const Divider(),

          // 📋 lista de productos encontrados
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(child: Text("Error: $_error"))
                    : _productosFiltrados.isEmpty
                        ? const Center(child: Text("No se encontraron productos"))
                        : ListView.builder(
                            itemCount: _productosFiltrados.length,
                            itemBuilder: (context, index) {
                              final p = _productosFiltrados[index];
                              return Card(
                                margin: const EdgeInsets.all(6),
                                child: ListTile(
                                  title: Text(p["nombre"]),
                                  subtitle: Text(
                                      "${p["descripcion"]} - \$${p["precio"]} (Cat: ${p["categoria"]})"),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
