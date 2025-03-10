import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistroVehiculoScreen extends StatefulWidget {
  @override
  _RegistroVehiculoScreenState createState() => _RegistroVehiculoScreenState();
}

class _RegistroVehiculoScreenState extends State<RegistroVehiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> personas = [];
  Map<String, dynamic>? conductorSeleccionado;
  final TextEditingController patenteController = TextEditingController();
  final TextEditingController tipoVehiculoController = TextEditingController();
  String motivoVisita = 'entrevista';
  final TextEditingController comentarioController = TextEditingController();
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

  Future<void> _registrarVehiculo() async {
    if (!_formKey.currentState!.validate() || conductorSeleccionado == null) return;

    final token = await _getToken();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/v1/acceso_obra/RegistroVehiculo/'),
      headers: {'Authorization': 'Token $token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        "persona": conductorSeleccionado!['id'],
        "motivo_visita": motivoVisita,
        "comentario": comentarioController.text,
        "patente": patenteController.text,
        "tipo_vehiculo": tipoVehiculoController.text,
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
        SnackBar(content: Text("Error al registrar vehículo")),
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
      appBar: AppBar(title: Text("Registrar Acceso Vehículo")),
      body: Stack(
        children: [
          // 🔹 Fondo con círculos de colores
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
          // 🔹 Formulario desplazable dentro de un centro
          Center(
            child: SingleChildScrollView(
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
                        // 🔹 Campo de Autocompletado para seleccionar conductor
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
                                labelText: "Seleccionar Conductor",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) => conductorSeleccionado == null ? "Seleccione un conductor" : null,
                            );
                          },
                          onSelected: (Map<String, dynamic> selection) {
                            setState(() {
                              conductorSeleccionado = selection;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: patenteController,
                          decoration: InputDecoration(
                            labelText: "Patente",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) => value!.isEmpty ? "Ingrese la patente" : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: tipoVehiculoController,
                          decoration: InputDecoration(
                            labelText: "Tipo de Vehículo",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) => value!.isEmpty ? "Ingrese el tipo de vehículo" : null,
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
                          decoration: InputDecoration(
                            labelText: "Comentario",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: autorizadoPorController,
                          decoration: InputDecoration(
                            labelText: "Autorizado por",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _registrarVehiculo,
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
          ),
        ],
      ),
    );
  }
}