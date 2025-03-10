import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/novedades_service.dart';

class RegistrarNovedadScreen extends StatefulWidget {
  @override
  _RegistrarNovedadScreenState createState() => _RegistrarNovedadScreenState();
}

class _RegistrarNovedadScreenState extends State<RegistrarNovedadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController reportadoPorController = TextEditingController();
  final NovedadesService _novedadesService = NovedadesService();
  File? _imagenSeleccionada;

  final ImagePicker _picker = ImagePicker();

  /// Método para seleccionar una imagen desde la galería o la cámara
  Future<void> _seleccionarImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path);
      });
    }
  }

  /// Método para registrar la novedad
  Future<void> _registrarNovedad() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool resultado = await _novedadesService.registrarNovedadDiaria(
          tituloController.text,
          descripcionController.text,
          reportadoPorController.text,
          _imagenSeleccionada,
        );

        if (resultado) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al registrar la novedad diaria")),
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
      appBar: AppBar(title: Text("Registrar Novedad Diaria")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: tituloController,
                  decoration: InputDecoration(labelText: "Título"),
                  validator: (value) => value!.isEmpty ? "Ingrese un título" : null,
                ),
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
                SizedBox(height: 10),
                _imagenSeleccionada != null
                    ? Image.file(
                  _imagenSeleccionada!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )
                    : Text("No se ha seleccionado ninguna imagen"),
                ElevatedButton.icon(
                  onPressed: _seleccionarImagen,
                  icon: Icon(Icons.image),
                  label: Text("Seleccionar Imagen"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
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
      ),
    );
  }
}