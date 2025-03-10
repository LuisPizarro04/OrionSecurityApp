import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/novedad.dart';

class NovedadesService {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1/libro_novedades/';

  /// Obtiene el token de autenticación almacenado
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Obtiene las novedades diarias
  Future<List<NovedadDiaria>> obtenerNovedadesDiarias() async {
    return _fetchData<NovedadDiaria>('NovedadDiaria/', (json) => NovedadDiaria.fromJson(json));
  }

  /// Obtiene los reportes generales
  Future<List<ReporteGeneral>> obtenerReportesGenerales() async {
    return _fetchData<ReporteGeneral>('ReporteGeneral/', (json) => ReporteGeneral.fromJson(json));
  }

  /// Obtiene los reportes de incidentes
  Future<List<ReporteIncidente>> obtenerReportesIncidentes() async {
    return _fetchData<ReporteIncidente>('ReporteIncidente/', (json) => ReporteIncidente.fromJson(json));
  }

  /// Método genérico para obtener datos desde la API
  Future<List<T>> _fetchData<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener datos de $endpoint");
    }
  }

  /// Registra una nueva novedad diaria en la API con imagen opcional
  Future<bool> registrarNovedadDiaria(String titulo, String descripcion, String reportadoPor, File? imagen) async {
    return _postMultipartData(
      'NovedadDiaria/',
      {
        'titulo': titulo,
        'descripcion': descripcion,
        'reportado_por': reportadoPor,
      },
      imagen,
      'imagen', // Campo en la API
    );
  }

  /// Registra un nuevo reporte general en la API con archivo adjunto opcional
  Future<bool> registrarReporteGeneral(String titulo, String resumen, String elaboradoPor, File? archivoAdjunto) async {
    return _postMultipartData(
      'ReporteGeneral/',
      {
        'titulo': titulo,
        'resumen': resumen,
        'elaborado_por': elaboradoPor,
      },
      archivoAdjunto,
      'archivo_adjunto', // Campo en la API
    );
  }

  /// Registra un nuevo reporte de incidente en la API con evidencia opcional
  Future<bool> registrarReporteIncidente(
      String titulo,
      String descripcion,
      String reportadoPor,
      String estado,
      File? evidencia,
      String? comentarios,
      ) async {
    return _postMultipartData(
      'ReporteIncidente/',
      {
        'titulo': titulo,
        'descripcion': descripcion,
        'reportado_por': reportadoPor,
        'estado': estado,
        'comentarios': comentarios ?? "",
      },
      evidencia,
      'evidencia', // Campo en la API
    );
  }

  /// Método genérico para enviar datos con archivos opcionales usando MultipartRequest
  Future<bool> _postMultipartData(
      String endpoint, Map<String, String> fields, File? file, String fileFieldName) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl$endpoint');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Token $token';

    // Agregar campos de texto
    fields.forEach((key, value) {
    request.fields[key] = value;
    });

    // Agregar archivo si existe
    if (file != null) {
    request.files.add(await http.MultipartFile.fromPath(
    fileFieldName,
    file.path,
    contentType: MediaType('image', 'jpeg'), // Ajusta MIME si es necesario
    ));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
    return true;
    } else {
    print("❌ Error al registrar en $endpoint: $responseBody");
    return false;
    }
  }
}