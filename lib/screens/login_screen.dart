import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart'; // 🔹 Ahora redirige a la página principal después del login

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    bool success = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // 🔹 Redirige a HomeScreen
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Credenciales incorrectas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Fondo con imagen
          Positioned.fill(
            child: Image.asset(
              'assets/construction_bg.jpg', // 📌 Asegúrate de tener esta imagen en assets
              fit: BoxFit.cover,
            ),
          ),
          // 🔹 Capa de transparencia para mejorar la legibilidad
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // 🔹 Formulario de Login
          Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Container(
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 Logo de la empresa (opcional)
                    Image.asset(
                      'assets/logo_empresa.png', // 📌 Asegúrate de agregar este logo en assets
                      height: 80,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Seguridad en Obra",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4b3a06),
                      ),
                    ),
                    SizedBox(height: 20),
                    // 🔹 Campo Usuario
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: Icon(Icons.person, color: Color(0xFFEB6608)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    // 🔹 Campo Contraseña
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFEB6608)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    // 🔹 Botón de Login
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Color(0xFFEB6608),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Ingresar",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}