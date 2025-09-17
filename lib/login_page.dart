import 'package:flutter/material.dart';
import 'login_service.dart';
import 'home_page.dart';
import 'register_page.dart'; // 👈 Importamos la pantalla de registro

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService _loginService = LoginService();
  String _mensaje = "";

  void _iniciarSesion() async {
    final usuario = _usuarioController.text.trim();
    final pass = _passwordController.text.trim();

    final respuesta = await _loginService.login(usuario, pass);

    if (respuesta["success"] == true) {
      setState(() {
        _mensaje = "¡Login exitoso!";
      });

      // 👇 Mostrar datos en consola
      final datosUsuario = respuesta["usuario"][0];
      print("Login exitoso:");
      print("Cedula: ${datosUsuario["cedulaUsuario"]}");
      print("Nombres: ${datosUsuario["nombresUsuario"]}");
      print("Apellidos: ${datosUsuario["apellidosUsuarios"]}");

      // Redirigir a HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            nombres: datosUsuario["nombresUsuario"],
            apellidos: datosUsuario["apellidosUsuarios"],
          ),
        ),
      );
    } else {
      setState(() {
        _mensaje = respuesta["message"] ?? "Usuario o contraseña incorrectos";
      });
    }
  }

  void _irARegistro() async {
    final nuevoUsuario = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );

    // 👇 Si el registro devolvió el nombre de usuario, lo rellenamos
    if (nuevoUsuario != null && nuevoUsuario is String) {
      setState(() {
        _usuarioController.text = nuevoUsuario;
        _mensaje = "Usuario registrado, ahora ingresa la contraseña";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bienvenido",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Ingresa tus credenciales"),

              const SizedBox(height: 30),
              TextField(
                controller: _usuarioController,
                decoration: const InputDecoration(
                  labelText: "Usuario",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _iniciarSesion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Ingresar"),
              ),

              const SizedBox(height: 20),
              Text(
                _mensaje,
                style: const TextStyle(color: Colors.red),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: _irARegistro,
                child: const Text("¿No tienes cuenta? Regístrate aquí"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
