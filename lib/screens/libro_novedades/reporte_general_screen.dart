import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/novedades_service.dart';

class ReporteGeneralScreen extends StatefulWidget {
  @override
  _ReporteGeneralScreenState createState() => _ReporteGeneralScreenState();
}

class _ReporteGeneralScreenState extends State<ReporteGeneralScreen> {
  final _formKey = GlobalKey<FormState>();

  // ✅ Agregar controladores
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController resumenController = TextEditingController();
  final TextEditingController elaboradoPorController = TextEditingController();

  final NovedadesService _novedadesService = NovedadesService();

  File? _archivoAdjunto; // Para manejar el archivo adjunto
  final picker = ImagePicker(); // Para seleccionar archivos

  // ✅ Método para seleccionar archivo adjunto
  Future<void> _seleccionarArchivo() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _archivoAdjunto = File(pickedFile.path);
      });
    }
  }

  // ✅ Método para registrar el reporte
  Future<void> _registrarReporteGeneral() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _novedadesService.registrarReporteGeneral(
          tituloController.text,
          resumenController.text,
          elaboradoPorController.text,
          _archivoAdjunto,  // ✅ Pasar File? en lugar de _archivoAdjunto?.path
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
                controller: tituloController, // ✅ Ahora está definido
                decoration: InputDecoration(labelText: "Título"),
                validator: (value) => value!.isEmpty ? "Ingrese un título" : null,
              ),
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _seleccionarArchivo,
                    icon: Icon(Icons.attach_file),
                    label: Text("Adjuntar archivo"),
                  ),
                  if (_archivoAdjunto != null) Text("Archivo seleccionado"),
                ],
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