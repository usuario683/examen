import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_service.dart';

class ProductosService {
  final Dio _dio = Dio();

  Future<List<dynamic>> listarProductos() async {
    try {
      final response = await _dio.get("${ApiService.baseUrl}/productos.php");

      if (response.data is String) {
        return jsonDecode(response.data);
      }
      return response.data;
    } on DioException catch (e) {
      throw Exception("Error al obtener productos: ${e.message}");
    }
  }

  Future<Map<String, dynamic>> crearProducto(
      String nombre, String descripcion, double precio, int idCategoria) async {
    try {
      final response = await _dio.post(
        "${ApiService.baseUrl}/productos.php",
        data: {
          "nombre": nombre,
          "descripcion": descripcion,
          "precio": precio,
          "idCategoria": idCategoria,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return response.data;
    } on DioException catch (e) {
      return {"success": false, "message": "Error: ${e.message}"};
    }
  }
}
