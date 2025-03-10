import 'package:flutter/material.dart';
import '../../models/novedad.dart';
import '../../services/novedades_service.dart';
import '../home_screen.dart';
import 'registrar_novedad_screen.dart';
import 'reporte_general_screen.dart';
import 'reporte_incidente_screen.dart';
import 'listado_novedades_screen.dart';
import 'listado_reportes_generales_screen.dart';
import 'listado_reportes_incidentes_screen.dart';

class NovedadesScreen extends StatefulWidget {
  @override
  _NovedadesScreenState createState() => _NovedadesScreenState();
}

class _NovedadesScreenState extends State<NovedadesScreen> {
  final NovedadesService _novedadesService = NovedadesService();
  late Future<List<NovedadDiaria>> _novedadesDiarias;
  late Future<List<ReporteGeneral>> _reportesGenerales;
  late Future<List<ReporteIncidente>> _reportesIncidentes;

  @override
  void initState() {
    super.initState();
    _fetchNovedades();
  }

  void _fetchNovedades() {
    setState(() {
      _novedadesDiarias = _novedadesService.obtenerNovedadesDiarias();
      _reportesGenerales = _novedadesService.obtenerReportesGenerales();
      _reportesIncidentes = _novedadesService.obtenerReportesIncidentes();
    });
  }

  String _formatFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  Widget _buildSection<T>(
      String title, Future<List<T>> future, Widget Function(T) itemBuilder, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap, // ✅ Redirige a la pantalla correspondiente al tocar el título
            child: Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          FutureBuilder<List<T>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("Error al cargar datos")),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text("No hay registros disponibles")),
                );
              }

              var items = snapshot.data!.take(3).toList(); // ✅ Muestra solo las últimas 3 entradas
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) => itemBuilder(items[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNovedadItem(NovedadDiaria novedad) {
    return ListTile(
      leading: Icon(Icons.article, color: Colors.blue),
      title: Text(novedad.titulo, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${_formatFecha(novedad.fecha)} - Reportado por: ${novedad.reportadoPor}"),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Acción al tocar una novedad (Ej: ver detalles)
      },
    );
  }

  Widget _buildReporteGeneralItem(ReporteGeneral reporte) {
    return ListTile(
      leading: Icon(Icons.insert_drive_file, color: Colors.green),
      title: Text(reporte.titulo, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${_formatFecha(reporte.fecha)} - Elaborado por: ${reporte.elaboradoPor}"),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Acción al tocar un reporte general
      },
    );
  }

  Widget _buildReporteIncidenteItem(ReporteIncidente incidente) {
    return ListTile(
      leading: Icon(Icons.warning, color: Colors.red),
      title: Text(incidente.titulo, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${_formatFecha(incidente.fechaReporte)} - Estado: ${incidente.estado}"),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Acción al tocar un reporte de incidente
      },
    );
  }

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrarNovedadScreen())),
          label: Text("Nueva Novedad"),
          icon: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReporteGeneralScreen())),
          label: Text("Nuevo Reporte"),
          icon: Icon(Icons.assignment),
          backgroundColor: Colors.green,
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReporteIncidenteScreen())),
          label: Text("Nuevo Incidente"),
          icon: Icon(Icons.warning),
          backgroundColor: Colors.red,
        ),
      ],
    );
  }

  void _cargarNovedades() {
    setState(() {
      _fetchNovedades();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Libro de Novedades"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _cargarNovedades, // 🔄 Recargar novedades al presionar el botón
          ),
        ],
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menú de Navegación",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Inicio"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/dashboard");
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Libro de Novedades"),
              selected: true,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSection<NovedadDiaria>("Novedades Diarias", _novedadesDiarias, _buildNovedadItem,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => NovedadesDiariasScreen()))),
            _buildSection<ReporteGeneral>("Reportes Generales", _reportesGenerales, _buildReporteGeneralItem,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportesGeneralesScreen()))),
            _buildSection<ReporteIncidente>("Reportes de Incidentes", _reportesIncidentes, _buildReporteIncidenteItem,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportesIncidentesScreen()))),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }
}