import 'package:flutter/material.dart';
import '../../models/novedad.dart';

class DetalleReporteGeneralScreen extends StatelessWidget {
  final ReporteGeneral reporte;

  DetalleReporteGeneralScreen({required this.reporte});

  String _formatFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(reporte.titulo)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha: ${_formatFecha(reporte.fecha)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Elaborado por: ${reporte.elaboradoPor}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(reporte.resumen, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            if (reporte.archivoAdjunto != null)
              ElevatedButton(
                onPressed: () {
                  // Implementar la descarga o visualización del archivo
                },
                child: Text("Ver archivo adjunto"),
              ),
          ],
        ),
      ),
    );
  }
}