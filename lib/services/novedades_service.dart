import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/novedad.dart';

class NovedadesService {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1/libro_novedades/';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<Novedad>> obtenerNovedadesDiarias() async {
    return _fetchData('NovedadDiaria/');
  }

  Future<List<Novedad>> obtenerReportesGenerales() async {
    return _fetchData('ReporteGeneral/');
  }

  Future<List<Novedad>> obtenerReportesIncidentes() async {
    return _fetchData('ReporteIncidente/');
  }

  Future<List<Novedad>> _fetchData(String endpoint) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Authorization': 'Token $token', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Novedad.fromJson(json)).toList(); // 🔹 Convertir a List<Novedad>
    } else {
      throw Exception("Error al obtener datos de $endpoint");
    }
  }

  registrarReporteGeneral(String text, String text2) {}

  registrarNovedadDiaria(String text, String text2) {}

  registrarReporteIncidente(String text, String text2, String estadoSeleccionado, String text3) {}
}