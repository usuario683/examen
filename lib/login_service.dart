import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_service.dart';

class LoginService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login(String usuario, String contrasenia) async {
    try {
      final response = await _dio.get(
        "${ApiService.baseUrl}/login.php",
        queryParameters: {
          "nomloginUsuario": usuario,
          "contraseniaUsario": contrasenia,
        },
      );

      // 👇 Si ya es Map (JSON), lo devolvemos directo
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }

      // 👇 Si viene como String, lo convertimos a JSON
      if (response.data is String) {
        return jsonDecode(response.data);
      }

      return {
        "success": false,
        "message": "Formato inesperado: ${response.data.toString()}"
      };
    } on DioException catch (e) {
      return {
        "success": false,
        "message": "Error de conexión con la API: ${e.message}"
      };
    }
  }
}
