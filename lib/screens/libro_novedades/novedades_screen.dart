import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../dashboard_screen.dart';
import '../home_screen.dart';
import 'registrar_novedad_screen.dart';
import 'reporte_general_screen.dart';
import 'reporte_incidente_screen.dart';
import '../../models/novedad.dart';
import '../../services/novedades_service.dart';

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

  String _formatFecha(String fechaISO) {
    DateTime fecha = DateTime.parse(fechaISO);
    return DateFormat('dd/MM/yyyy HH:mm').format(fecha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text("Libro de Novedades"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _cargarDatos)],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(child: _buildSection("📌 Novedades Diarias", novedadesDiarias, Icons.event_note, Colors.orange)),
          Expanded(child: _buildSection("📋 Reportes Generales", reportesGenerales, Icons.assignment, Colors.green)),
          Expanded(child: _buildSection("⚠️ Reportes de Incidentes", reportesIncidentes, Icons.warning, Colors.red)),
        ],
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildSection(String title, List<Novedad> registros, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Encabezado de la sección
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withAlpha(230),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),

        // 🔹 Lista de registros
        Expanded(
          child: registros.isEmpty
              ? Center(
            child: Text("No hay registros disponibles", style: TextStyle(fontSize: 16, color: Colors.grey)),
          )
              : ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final novedad = registros[index];

              return Container(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2)],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: color.withAlpha(204),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  title: Text(
                    novedad.descripcion,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Reportado por: ${novedad.reportadoPor}", style: TextStyle(fontSize: 14)),
                      Text("Fecha: ${_formatFecha(novedad.fecha)}", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildButton(
              icon: Icons.event_note,
              label: "Novedad",
              color: Colors.blue,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrarNovedadScreen()))
                  .then((_) => _cargarDatos()),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: _buildButton(
              icon: Icons.assignment,
              label: "Reporte",
              color: Colors.green,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReporteGeneralScreen()))
                  .then((_) => _cargarDatos()),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: _buildButton(
              icon: Icons.warning,
              label: "Incidente",
              color: Colors.red,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReporteIncidentesScreen()))
                  .then((_) => _cargarDatos()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required IconData icon, required String label, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          SizedBox(height: 3),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ],
      ),
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
            leading: Icon(Icons.book),
            title: Text("Libro de Novedades"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NovedadesScreen()),
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