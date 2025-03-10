import 'package:flutter/material.dart';
import '../../services/novedades_service.dart';

class ReporteIncidentesScreen extends StatefulWidget {
  @override
  _ReporteIncidentesScreenState createState() => _ReporteIncidentesScreenState();
}

class _ReporteIncidentesScreenState extends State<ReporteIncidentesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController reportadoPorController = TextEditingController();
  final TextEditingController comentariosController = TextEditingController();
  final NovedadesService _novedadesService = NovedadesService();
  String estadoSeleccionado = 'pendiente';

  Future<void> _registrarIncidente() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _novedadesService.registrarReporteIncidente(
          descripcionController.text,
          reportadoPorController.text,
          estadoSeleccionado,
          comentariosController.text,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al registrar el incidente")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Reporte de Incidente")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: "Descripción del incidente"),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Ingrese una descripción" : null,
              ),
              TextFormField(
                controller: reportadoPorController,
                decoration: InputDecoration(labelText: "Reportado por"),
                validator: (value) => value!.isEmpty ? "Ingrese el nombre del reportante" : null,
              ),
              DropdownButtonFormField(
                value: estadoSeleccionado,
                items: [
                  DropdownMenuItem(value: 'pendiente', child: Text("Pendiente")),
                  DropdownMenuItem(value: 'en_progreso', child: Text("En progreso")),
                  DropdownMenuItem(value: 'resuelto', child: Text("Resuelto")),
                ],
                onChanged: (value) => setState(() => estadoSeleccionado = value.toString()),
                decoration: InputDecoration(labelText: "Estado del incidente"),
              ),
              TextFormField(
                controller: comentariosController,
                decoration: InputDecoration(labelText: "Comentarios adicionales"),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarIncidente,
                child: Text("Registrar"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}