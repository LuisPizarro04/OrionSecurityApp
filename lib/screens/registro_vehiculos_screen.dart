import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

class RegistroVehiculoScreen extends StatefulWidget {
  @override
  _RegistroVehiculoScreenState createState() => _RegistroVehiculoScreenState();
}

class _RegistroVehiculoScreenState extends State<RegistroVehiculoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController personaController = TextEditingController();
  final TextEditingController empresaController = TextEditingController();
  final TextEditingController patenteController = TextEditingController();
  final TextEditingController comentarioController = TextEditingController();
  final TextEditingController autorizadoPorController = TextEditingController();

  String motivoVisita = 'entrevista';
  String tipoVehiculo = 'automovil';

  final List<Map<String, String>> motivosVisita = [
    {'value': 'entrevista', 'label': 'Entrevista'},
    {'value': 'contratacion', 'label': 'Contratación'},
    {'value': 'entrega_material', 'label': 'Entrega Material'},
    {'value': 'visita_general', 'label': 'Visita General'},
  ];

  final List<Map<String, String>> tiposVehiculo = [
    {'value': 'automovil', 'label': 'Automóvil'},
    {'value': 'camioneta', 'label': 'Camioneta'},
    {'value': 'camion', 'label': 'Camión'},
    {'value': 'moto', 'label': 'Motocicleta'},
    {'value': 'maquinaria', 'label': 'Maquinaria Pesada'},
    {'value': 'otro', 'label': 'Otro'},
  ];

  Future<void> _registrarVehiculo() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await _getToken();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/v1/acceso_obra/RegistroVehiculo/'),
      headers: {'Authorization': 'Token $token', 'Content-Type': 'application/json'},
      body: jsonEncode({
        "persona": personaController.text,
        "empresa": empresaController.text.isNotEmpty ? empresaController.text : null,
        "motivo_visita": motivoVisita,
        "patente": patenteController.text,
        "tipo_vehiculo": tipoVehiculo,
        "autorizado_por": autorizadoPorController.text.isNotEmpty ? autorizadoPorController.text : null,
        "comentario": comentarioController.text,
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: personaController,
                  decoration: InputDecoration(labelText: "Nombre del Conductor"),
                  validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: empresaController,
                  decoration: InputDecoration(labelText: "Empresa (Opcional)"),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: motivoVisita,
                  items: motivosVisita.map<DropdownMenuItem<String>>((motivo) {
                    return DropdownMenuItem<String>(
                      value: motivo['value'],
                      child: Text(motivo['label']!),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => motivoVisita = value!),
                  decoration: InputDecoration(labelText: "Motivo de Visita"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: patenteController,
                  decoration: InputDecoration(labelText: "Patente del Vehículo"),
                  validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: tipoVehiculo,
                  items: tiposVehiculo.map<DropdownMenuItem<String>>((tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo['value'],
                      child: Text(tipo['label']!),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => tipoVehiculo = value!),
                  decoration: InputDecoration(labelText: "Tipo de Vehículo"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: comentarioController,
                  decoration: InputDecoration(labelText: "Comentario"),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: autorizadoPorController,
                  decoration: InputDecoration(labelText: "Autorizado Por (Opcional)"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registrarVehiculo,
                  child: Text("Registrar Vehículo"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}