import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistroPersonaScreen extends StatefulWidget {
  @override
  _RegistroPersonaScreenState createState() => _RegistroPersonaScreenState();
}

class _RegistroPersonaScreenState extends State<RegistroPersonaScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> personas = [];
  Map<String, dynamic>? personaSeleccionada;
  String motivoVisita = 'entrevista';
  final TextEditingController comentarioController = TextEditingController();
  String metodoVerificacion = 'qr';
  final TextEditingController autorizadoPorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPersonas();
  }

  Future<void> fetchPersonas() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/v1/acceso_obra/PersonaAcceso/'),
      headers: {'Authorization': 'Token $token', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        personas = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      print("❌ Error al obtener personas: ${response.body}");
    }
  }

  Future<void> _registrarPersona() async {
    if (!_formKey.currentState!.validate() || personaSeleccionada == null) return;

    final token = await _getToken();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/v1/acceso_obra/RegistroAcceso/'),
      headers: {'Authorization': 'Token $token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        "persona": personaSeleccionada!['id'],
        "motivo_visita": motivoVisita,
        "comentario": comentarioController.text,
        "metodo_verificacion": metodoVerificacion,
        "autorizado_por": autorizadoPorController.text
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar acceso")),
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
      appBar: AppBar(title: Text("Registrar Acceso Persona")),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFFEB6608).withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFF4AC0E8).withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 Campo de Autocompletado para seleccionar persona
                      Autocomplete<Map<String, dynamic>>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Map<String, dynamic>>.empty();
                          }
                          return personas.where((persona) => persona['nombre']
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                        },
                        displayStringForOption: (Map<String, dynamic> option) => option['nombre'],
                        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                            FocusNode focusNode, VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: "Seleccionar Persona",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (value) => personaSeleccionada == null ? "Seleccione una persona" : null,
                          );
                        },
                        onSelected: (Map<String, dynamic> selection) {
                          setState(() {
                            personaSeleccionada = selection;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: motivoVisita,
                        items: ["entrevista", "contratacion", "entrega_material", "visita_general"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) => setState(() => motivoVisita = value.toString()),
                        decoration: InputDecoration(labelText: "Motivo Visita"),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: comentarioController,
                        decoration: InputDecoration(labelText: "Comentario"),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: metodoVerificacion,
                        items: ["qr", "pin", "credencial"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) => setState(() => metodoVerificacion = value.toString()),
                        decoration: InputDecoration(labelText: "Método de Verificación"),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: autorizadoPorController,
                        decoration: InputDecoration(labelText: "Autorizado por"),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _registrarPersona,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEB6608),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Registrar", style: TextStyle(color: Colors.white, fontSize: 18)),
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