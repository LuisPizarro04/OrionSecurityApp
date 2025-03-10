import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/novedades_service.dart';

class ReporteIncidenteScreen extends StatefulWidget {
  @override
  _ReporteIncidenteScreenState createState() => _ReporteIncidenteScreenState();
}

class _ReporteIncidenteScreenState extends State<ReporteIncidenteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController reportadoPorController = TextEditingController();
  final TextEditingController comentariosController = TextEditingController();
  final NovedadesService _novedadesService = NovedadesService();
  String estadoSeleccionado = 'pendiente';
  File? _evidenciaSeleccionada;

  final ImagePicker _picker = ImagePicker();

  /// Método para seleccionar una imagen o archivo como evidencia
  Future<void> _seleccionarEvidencia() async {
    final XFile? evidencia = await _picker.pickImage(source: ImageSource.gallery);
    if (evidencia != null) {
      setState(() {
        _evidenciaSeleccionada = File(evidencia.path);
      });
    }
  }

  /// Método para registrar el incidente
  Future<void> _registrarIncidente() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool resultado = await _novedadesService.registrarReporteIncidente(
          tituloController.text,
          descripcionController.text,
          reportadoPorController.text,
          estadoSeleccionado,
          _evidenciaSeleccionada,
          comentariosController.text,
        );

        if (resultado) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al registrar el incidente")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error inesperado: $e")),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: tituloController,
                  decoration: InputDecoration(labelText: "Título del incidente"),
                  validator: (value) => value!.isEmpty ? "Ingrese un título" : null,
                ),
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
                SizedBox(height: 10),
                _evidenciaSeleccionada != null
                    ? Image.file(
                  _evidenciaSeleccionada!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )
                    : Text("No se ha seleccionado ninguna evidencia"),
                ElevatedButton.icon(
                  onPressed: _seleccionarEvidencia,
                  icon: Icon(Icons.attach_file),
                  label: Text("Seleccionar Evidencia"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
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
      ),
    );
  }
}