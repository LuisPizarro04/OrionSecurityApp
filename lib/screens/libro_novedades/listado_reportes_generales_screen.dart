import 'package:flutter/material.dart';
import '../../services/novedades_service.dart';
import '../../models/novedad.dart';
import 'detalle_rep_general_screen.dart';

class ReportesGeneralesScreen extends StatefulWidget {
  @override
  _ReportesGeneralesScreenState createState() => _ReportesGeneralesScreenState();
}

class _ReportesGeneralesScreenState extends State<ReportesGeneralesScreen> {
  final NovedadesService _novedadesService = NovedadesService();
  late Future<List<ReporteGeneral>> _reportesGenerales;

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  void _cargarReportes() {
    setState(() {
      _reportesGenerales = _novedadesService.obtenerReportesGenerales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reportes Generales"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _cargarReportes,
          ),
        ],
      ),
      body: FutureBuilder<List<ReporteGeneral>>(
        future: _reportesGenerales,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar reportes generales"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay reportes generales registrados."));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final reporte = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetalleReporteGeneralScreen(reporte: reporte)),
                    );
                  },
                  title: Text(reporte.titulo),
                  subtitle: Text(reporte.resumen),
                  trailing: Text(reporte.fecha.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}