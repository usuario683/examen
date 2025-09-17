// lib/register_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaCtrl = TextEditingController();
  final TextEditingController _nombresCtrl = TextEditingController();
  final TextEditingController _apellidosCtrl = TextEditingController();
  final TextEditingController _correoCtrl = TextEditingController();
  final TextEditingController _usuarioCtrl = TextEditingController();
  final TextEditingController _contraseniaCtrl = TextEditingController();

  bool _loading = false;
  final Dio _dio = Dio();

  // Cambia aquí tu IP si es otra
  static const String baseUrl = "http://192.168.18.7/APIJAPON_V1-main/APIAPPJAPON";

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final resp = await _dio.post(
        "$baseUrl/registro_usuario.php",
        data: {
          "cedulaUsuario": _cedulaCtrl.text.trim(),
          "nombresUsuario": _nombresCtrl.text.trim(),
          "apellidosUsuarios": _apellidosCtrl.text.trim(),
          "correoUsuario": _correoCtrl.text.trim(),
          "nomloginUsuario": _usuarioCtrl.text.trim(),
          "contraseniaUsario": _contraseniaCtrl.text.trim(),
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = resp.data;
      if (data is String) {
        // por si el servidor responde string JSON
        // intentar decode
      }

      if (data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario registrado correctamente ✅")),
        );
        // volver al login y opcionalmente pasar el usuario para autocompletar
        Navigator.pop(context, _usuarioCtrl.text.trim());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${data['message']}")),
        );
      }
    } on DioException catch (e) {
      String msg = e.message ?? "Error de conexión";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error inesperado: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _correoCtrl.dispose();
    _usuarioCtrl.dispose();
    _contraseniaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de usuario")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cedulaCtrl,
                decoration: const InputDecoration(labelText: "Cédula"),
                validator: (v) => (v==null || v.trim().isEmpty) ? "Ingrese cédula" : null,
              ),
              TextFormField(
                controller: _nombresCtrl,
                decoration: const InputDecoration(labelText: "Nombres"),
                validator: (v) => (v==null || v.trim().isEmpty) ? "Ingrese nombres" : null,
              ),
              TextFormField(
                controller: _apellidosCtrl,
                decoration: const InputDecoration(labelText: "Apellidos"),
                validator: (v) => (v==null || v.trim().isEmpty) ? "Ingrese apellidos" : null,
              ),
              TextFormField(
                controller: _correoCtrl,
                decoration: const InputDecoration(labelText: "Correo"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v==null || v.trim().isEmpty) return "Ingrese correo";
                  if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(v)) return "Correo inválido";
                  return null;
                },
              ),
              TextFormField(
                controller: _usuarioCtrl,
                decoration: const InputDecoration(labelText: "Usuario (login)"),
                validator: (v) => (v==null || v.trim().isEmpty) ? "Ingrese usuario" : null,
              ),
              TextFormField(
                controller: _contraseniaCtrl,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (v) => (v==null || v.trim().length < 4) ? "Mínimo 4 caracteres" : null,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text("Registrarse"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
