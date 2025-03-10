import 'package:flutter/material.dart';
import '../../models/novedad.dart';
import '../../services/novedades_service.dart';
import '../dashboard_screen.dart';
import '../home_screen.dart';
import 'registrar_novedad_screen.dart';
import 'reporte_general_screen.dart';
import 'reporte_incidente_screen.dart';

class NovedadesScreen extends StatefulWidget {
  @override
  _NovedadesScreenState createState() => _NovedadesScreenState();
}

class _NovedadesScreenState extends State<NovedadesScreen> {
  final NovedadesService _novedadesService = NovedadesService();
  List<Novedad> novedadesDiarias = [];
  List<Novedad> reportesGenerales = [];
  List<Novedad> reportesIncidentes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => isLoading = true);
    try {
      final dataNovedades = await _novedadesService.obtenerNovedadesDiarias();
      final dataGenerales = await _novedadesService.obtenerReportesGenerales();
      final dataIncidentes = await _novedadesService.obtenerReportesIncidentes();

      setState(() {
        novedadesDiarias = dataNovedades;
        reportesGenerales = dataGenerales;
        reportesIncidentes = dataIncidentes;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error al obtener datos: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(), // 🔹 Agregado menú lateral
      appBar: AppBar(
        title: Text("Libro de Novedades"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _cargarDatos,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildSection("📌 Novedades Diarias", novedadesDiarias, Icons.event_note, Colors.orange),
              _buildSection("📋 Reportes Generales", reportesGenerales, Icons.assignment, Colors.green),
              _buildSection("⚠️ Reportes de Incidentes", reportesIncidentes, Icons.warning, Colors.red),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  Widget _buildSection(String title, List<Novedad> registros, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ),
        registros.isEmpty
            ? Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(child: Text("No hay registros disponibles", style: TextStyle(fontSize: 16))),
        )
            : Column(
          children: registros.map((novedad) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Icon(icon, color: color, size: 30),
                title: Text(novedad.descripcion, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Reportado por: ${novedad.reportadoPor}"),
                    Text("Fecha: ${novedad.fecha}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  // Aquí podemos agregar la funcionalidad para ver detalles del reporte
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: "btn1",
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrarNovedadScreen()))
              .then((_) => _cargarDatos()),
          icon: Icon(Icons.event_note),
          label: Text("Novedad Diaria"),
          backgroundColor: Colors.blue,
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: "btn2",
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReporteGeneralScreen()))
              .then((_) => _cargarDatos()),
          icon: Icon(Icons.assignment),
          label: Text("Reporte General"),
          backgroundColor: Colors.green,
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: "btn3",
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReporteIncidentesScreen()))
              .then((_) => _cargarDatos()),
          icon: Icon(Icons.warning),
          label: Text("Incidente"),
          backgroundColor: Colors.red,
        ),
      ],
    );
  }

  // 🔹 Menú lateral igual que en el Dashboard
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
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
              Navigator.pop(context); // 🔹 Cierra el menú antes de navegar
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()), // 🔹 Redirige directamente a HomeScreen
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text("Dashboard de Accesos"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Cerrar Sesión"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
  }
