import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

class RegistroNuevaPersonaScreen extends StatefulWidget {
  @override
  _RegistroNuevaPersonaScreenState createState() => _RegistroNuevaPersonaScreenState();
}

class _RegistroNuevaPersonaScreenState extends State<RegistroNuevaPersonaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController identificacionController = TextEditingController();
  final TextEditingController empresaController = TextEditingController();

  String tipoPersona = 'empleado';
  bool isLoading = false;

  final List<Map<String, String>> tiposPersona = [
    {'value': 'empleado', 'label': 'Empleado'},
    {'value': 'proveedor', 'label': 'Proveedor'},
    {'value': 'visitante', 'label': 'Visitante'},
  ];

  Future<void> _registrarPersona() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final token = await _getToken();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/v1/acceso_obra/PersonaAcceso/'),
      headers: {'Authorization': 'Token $token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        "nombre": nombreController.text,
        "identificacion": identificacionController.text,
        "tipo_persona": tipoPersona,
        "empresa": empresaController.text.isEmpty ? null : empresaController.text,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar la persona")),
      );
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Nueva Persona")),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/construction_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(230),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Nueva Persona Autorizada",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4b3a06)),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: nombreController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person, color: Color(0xFFEB6608)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: identificacionController,
                        decoration: InputDecoration(
                          labelText: 'Número de Identificación',
                          prefixIcon: Icon(Icons.badge, color: Color(0xFFEB6608)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: tipoPersona,
                        items: tiposPersona.map((tipo) {
                          return DropdownMenuItem<String>(
                            value: tipo['value'],
                            child: Text(tipo['label']!),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => tipoPersona = value!),
                        decoration: InputDecoration(
                          labelText: "Tipo de Persona",
                          prefixIcon: Icon(Icons.category, color: Color(0xFFEB6608)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: empresaController,
                        decoration: InputDecoration(
                          labelText: 'Empresa (Opcional)',
                          prefixIcon: Icon(Icons.business, color: Color(0xFFEB6608)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _registrarPersona,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Color(0xFFEB6608),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            "Registrar",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}