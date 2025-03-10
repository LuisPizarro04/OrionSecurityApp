import 'package:flutter/material.dart';
import '../../services/novedades_service.dart';

class RegistrarNovedadScreen extends StatefulWidget {
  @override
  _RegistrarNovedadScreenState createState() => _RegistrarNovedadScreenState();
}

class _RegistrarNovedadScreenState extends State<RegistrarNovedadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController reportadoPorController = TextEditingController();
  final NovedadesService _novedadesService = NovedadesService();

  Future<void> _registrarNovedad() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _novedadesService.registrarNovedadDiaria(
          descripcionController.text,
          reportadoPorController.text,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al registrar la novedad diaria")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Novedad Diaria")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: "Descripción"),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Ingrese una descripción" : null,
              ),
              TextFormField(
                controller: reportadoPorController,
                decoration: InputDecoration(labelText: "Reportado por"),
                validator: (value) => value!.isEmpty ? "Ingrese el nombre del reportante" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarNovedad,
                child: Text("Registrar"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}