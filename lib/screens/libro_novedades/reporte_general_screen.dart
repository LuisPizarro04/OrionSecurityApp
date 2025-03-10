import 'package:flutter/material.dart';
import '../../services/novedades_service.dart';

class ReporteGeneralScreen extends StatefulWidget {
  @override
  _ReporteGeneralScreenState createState() => _ReporteGeneralScreenState();
}

class _ReporteGeneralScreenState extends State<ReporteGeneralScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController resumenController = TextEditingController();
  final TextEditingController elaboradoPorController = TextEditingController();
  final NovedadesService _novedadesService = NovedadesService();

  Future<void> _registrarReporteGeneral() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _novedadesService.registrarReporteGeneral(
          resumenController.text,
          elaboradoPorController.text,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al registrar el reporte general")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Reporte General")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: resumenController,
                decoration: InputDecoration(labelText: "Resumen del día"),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Ingrese un resumen" : null,
              ),
              TextFormField(
                controller: elaboradoPorController,
                decoration: InputDecoration(labelText: "Elaborado por"),
                validator: (value) => value!.isEmpty ? "Ingrese el nombre del responsable" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarReporteGeneral,
                child: Text("Registrar"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}