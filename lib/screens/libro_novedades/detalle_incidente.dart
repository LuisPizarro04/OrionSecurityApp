import 'package:flutter/material.dart';
import '../../models/novedad.dart';

class DetalleReporteIncidenteScreen extends StatelessWidget {
  final ReporteIncidente incidente;

  DetalleReporteIncidenteScreen({required this.incidente});

  String _formatFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(incidente.titulo)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha: ${_formatFecha(incidente.fechaReporte)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Reportado por: ${incidente.reportadoPor}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Estado: ${incidente.estado}",
                style: TextStyle(fontSize: 16, color: Colors.red)),
            SizedBox(height: 20),
            Text(incidente.descripcion, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            if (incidente.evidencia != null)
              Image.network(
                incidente.evidencia!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            if (incidente.comentarios != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("Comentarios: ${incidente.comentarios}",
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              ),
          ],
        ),
      ),
    );
  }
}