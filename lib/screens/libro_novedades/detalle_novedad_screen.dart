import 'package:flutter/material.dart';
import '../../models/novedad.dart';

class DetalleNovedadScreen extends StatelessWidget {
  final NovedadDiaria novedad;

  DetalleNovedadScreen({required this.novedad});

  String _formatFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(novedad.titulo)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha: ${_formatFecha(novedad.fecha)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Reportado por: ${novedad.reportadoPor}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(novedad.descripcion, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            if (novedad.imagen != null)
              Image.network(
                novedad.imagen!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
          ],
        ),
      ),
    );
  }
}