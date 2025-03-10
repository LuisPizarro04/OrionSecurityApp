import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:segcdm/screens/registro_personas_screen.dart';
import 'package:segcdm/screens/registro_vehiculos_screen.dart';
import 'package:segcdm/screens/registro_nueva_persona_screen.dart'; // Nueva pantalla para registrar persona
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/registro_acceso.dart';
import '../models/registro_vehiculo.dart';
import 'package:intl/intl.dart';

import 'home_screen.dart';
import 'libro_novedades/novedades_screen.dart'; // Importar intl


String _formatFecha(String fechaISO) {
  DateTime fecha = DateTime.parse(fechaISO);
  return DateFormat('dd/MM/yyyy HH:mm').format(fecha);
}


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1/acceso_obra';
  List<RegistroAcceso> accesosPersonas = [];
  List<RegistroVehiculo> accesosVehiculos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final token = await _getToken();
      final headers = {'Authorization': 'Token $token', 'Content-Type': 'application/json'};

      final responsePersonas = await http.get(Uri.parse('$baseUrl/RegistroAcceso/'), headers: headers);
      final responseVehiculos = await http.get(Uri.parse('$baseUrl/RegistroVehiculo/'), headers: headers);

      if (responsePersonas.statusCode == 200 && responseVehiculos.statusCode == 200) {
        setState(() {
          accesosPersonas = (jsonDecode(responsePersonas.body) as List)
              .map((data) => RegistroAcceso.fromJson(data))
              .toList();

          accesosVehiculos = (jsonDecode(responseVehiculos.body) as List)
              .map((data) => RegistroVehiculo.fromJson(data))
              .toList();

          isLoading = false;
        });
      } else {
        print("❌ Error al obtener datos: ${responsePersonas.body} | ${responseVehiculos.body}");
      }
    } catch (e) {
      print("❌ Error: $e");
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  void _logout() async {
    await AuthService().logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: fetchData),
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: _logout),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: _buildSection(
              "Registros de Personas",
              accesosPersonas,
              Icons.person,
              Colors.blueAccent, // 🔹 Color para la sección de personas
            ),
          ),
          Expanded(
            child: _buildSection(
              "Registros de Vehículos",
              accesosVehiculos,
              Icons.directions_car,
              Colors.orangeAccent, // 🔹 Color para la sección de vehículos
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildSection(String title, List<dynamic> registros, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Encabezado de la sección con diseño llamativo
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

        // 🔹 Contenedor con diseño atractivo
        Expanded(
          child: registros.isEmpty
              ? Center(
            child: Text("No hay registros disponibles", style: TextStyle(fontSize: 16, color: Colors.grey)),
          )
              : ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final registro = registros[index];

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
                    "Nombre: ${registro is RegistroVehiculo ? registro.persona : registro.persona.nombre}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Motivo: ${registro.motivoVisita}", style: TextStyle(fontSize: 14)),
                      Text("Fecha: ${_formatFecha(registro.fechaHoraEntrada)}", style: TextStyle(fontSize: 14)),
                      if (registro is RegistroVehiculo && registro.empresa != null && registro.empresa!.isNotEmpty)
                        Text("Empresa: ${registro.empresa}", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
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
              icon: Icons.person_add,
              label: "Nueva Persona",
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistroNuevaPersonaScreen()),
                ).then((_) => fetchData());
              },
            ),
          ),
          SizedBox(width: 5), // Espacio entre botones
          Expanded(
            child: _buildButton(
              icon: Icons.how_to_reg,
              label: "Ingreso Persona",
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistroPersonaScreen()),
                ).then((_) => fetchData());
              },
            ),
          ),
          SizedBox(width: 5), // Espacio entre botones
          Expanded(
            child: _buildButton(
              icon: Icons.directions_car,
              label: "Ingreso Vehículo",
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistroVehiculoScreen()),
                ).then((_) => fetchData());
              },
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