import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard_screen.dart';
import 'libro_novedades/novedades_screen.dart';
import 'registro_personas_screen.dart';
import 'registro_vehiculos_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1/acceso_obra';
  int cantidadPersonas = 0;
  int cantidadVehiculos = 0;
  int trabajadoresPropios = 0;
  int trabajadoresSubcontratados = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIndicators();
  }

  Future<void> fetchIndicators() async {
    try {
      final token = await _getToken();
      final headers = {'Authorization': 'Token $token', 'Content-Type': 'application/json'};

      final responsePersonas = await http.get(Uri.parse('$baseUrl/RegistroAcceso/'), headers: headers);
      final responseVehiculos = await http.get(Uri.parse('$baseUrl/RegistroVehiculo/'), headers: headers);

      if (responsePersonas.statusCode == 200 && responseVehiculos.statusCode == 200) {
        List<dynamic> personas = jsonDecode(responsePersonas.body);
        List<dynamic> vehiculos = jsonDecode(responseVehiculos.body);

        setState(() {
          cantidadPersonas = personas.length;
          cantidadVehiculos = vehiculos.length;
          trabajadoresPropios = personas.where((p) => p['tipo_persona'] == 'empleado').length;
          trabajadoresSubcontratados = personas.where((p) => p['tipo_persona'] == 'proveedor').length;
          isLoading = false;
        });
      } else {
        print("❌ Error al obtener indicadores");
      }
    } catch (e) {
      print("❌ Error: $e");
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(), // 🔹 Menú lateral
      appBar: AppBar(
        title: Text("Inicio"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            _buildIndicatorsGrid(), // 🔹 Indicadores en una matriz
            SizedBox(height: 20),
            _buildActionButtons(), // 🔹 Botones de acceso rápido
          ],
        ),
      ),
    );
  }

  // 🔹 Indicadores en formato de matriz
  Widget _buildIndicatorsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildIndicatorCard("🚗 Vehículos ingresados", cantidadVehiculos, Colors.blue),
        _buildIndicatorCard("👤 Personas ingresadas", cantidadPersonas, Colors.green),
        _buildIndicatorCard("🏗️ Trabajadores Propios", trabajadoresPropios, Colors.orange),
        _buildIndicatorCard("🔨 Subcontratados", trabajadoresSubcontratados, Colors.red),
      ],
    );
  }

  Widget _buildIndicatorCard(String title, int count, Color color) {
    return Card(
      color: color.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "$count",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Botones de acceso rápido para registros
  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.person_add),
          label: Text("Registrar Persona"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistroPersonaScreen()),
            );
          },
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          icon: Icon(Icons.directions_car),
          label: Text("Registrar Vehículo"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistroVehiculoScreen()),
            );
          },
        ),
      ],
    );
  }

  // 🔹 Menú lateral con opciones de navegación
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
            leading: Icon(Icons.dashboard),
            title: Text("Dashboard de Accesos"),
            onTap: () {
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
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}