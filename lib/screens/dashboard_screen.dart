import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:segcdm/screens/registro_personas_screen.dart';
import 'package:segcdm/screens/registro_vehiculos_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/registro_acceso.dart';
import '../models/registro_vehiculo.dart';
import 'home_screen.dart';
import 'libro_novedades/novedades_screen.dart';

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
      drawer: _buildDrawer(), // 🔹 Menú lateral agregado
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
      body: Stack(
        children: [
          // 🔹 Fondo con detalles geométricos
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFFEB6608).withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFF4AC0E8).withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
              children: [
                _buildSection("Registros de Personas", accesosPersonas, Icons.person),
                SizedBox(height: 20),
                _buildSection("Registros de Vehículos", accesosVehiculos, Icons.directions_car),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  Widget _buildSection(String title, List<dynamic> registros, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4b3a06))),
          SizedBox(height: 10),
          Expanded(
            child: registros.isEmpty
                ? Center(child: Text("No hay registros", style: TextStyle(fontSize: 16)))
                : ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(icon, color: Color(0xFFEB6608), size: 30),
                    title: Text(
                      "Motivo: ${registro.motivoVisita}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Fecha: ${registro.fechaHoraEntrada}"),
                    trailing: registro is RegistroVehiculo
                        ? Text("Patente: ${registro.patente}", style: TextStyle(fontWeight: FontWeight.bold))
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: "btn1",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistroPersonaScreen()),
            ).then((_) => fetchData());
          },
          icon: Icon(Icons.person_add),
          label: Text("Acceso Persona"),
          backgroundColor: Color(0xFFEB6608),
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: "btn2",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistroVehiculoScreen()),
            ).then((_) => fetchData());
          },
          icon: Icon(Icons.directions_car),
          label: Text("Acceso Vehículo"),
          backgroundColor: Color(0xFF4AC0E8),
        ),
      ],
    );
  }

// 🔹 Menú lateral actualizado con navegación correcta
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
              Navigator.pop(context); // Cierra el menú
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()), // 🔹 Redirige correctamente
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
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NovedadesScreen()), // 🔹 Agregada opción de Novedades
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