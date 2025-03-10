import 'package:flutter/material.dart';
import '../../services/novedades_service.dart';
import '../../models/novedad.dart';

class ReportesIncidentesScreen extends StatefulWidget {
  @override
  _ReportesIncidentesScreenState createState() => _ReportesIncidentesScreenState();
}

class _ReportesIncidentesScreenState extends State<ReportesIncidentesScreen> {
  final NovedadesService _novedadesService = NovedadesService();
  late Future<List<ReporteIncidente>> _reportesIncidentes;

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  void _cargarReportes() {
    setState(() {
      _reportesIncidentes = _novedadesService.obtenerReportesIncidentes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reportes de Incidentes"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _cargarReportes,
          ),
        ],
      ),
      body: FutureBuilder<List<ReporteIncidente>>(
        future: _reportesIncidentes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar reportes de incidentes"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay reportes de incidentes registrados."));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final reporte = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(reporte.titulo),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reporte.descripcion),
                      Text("Estado: ${reporte.estado}"),
                    ],
                  ),
                  trailing: Text(reporte.fechaReporte.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}