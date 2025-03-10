import 'dart:convert';

class NovedadDiaria {
  final int id;
  final String titulo;
  final DateTime fecha;
  final String descripcion;
  final String reportadoPor;
  final String? imagen; // Puede ser nulo si no hay imagen adjunta

  NovedadDiaria({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.descripcion,
    required this.reportadoPor,
    this.imagen,
  });

  factory NovedadDiaria.fromJson(Map<String, dynamic> json) {
    return NovedadDiaria(
      id: json['id'],
      titulo: json['titulo'],
      fecha: DateTime.parse(json['fecha']), // Convertir string a DateTime
      descripcion: json['descripcion'],
      reportadoPor: json['reportado_por'],
      imagen: json['imagen'], // Puede ser null
    );
  }
}

class ReporteIncidente {
  final int id;
  final String titulo;
  final DateTime fechaReporte;
  final String descripcion;
  final String reportadoPor;
  final String estado;
  final String? evidencia;
  final String? comentarios;

  ReporteIncidente({
    required this.id,
    required this.titulo,
    required this.fechaReporte,
    required this.descripcion,
    required this.reportadoPor,
    required this.estado,
    this.evidencia,
    this.comentarios,
  });

  factory ReporteIncidente.fromJson(Map<String, dynamic> json) {
    return ReporteIncidente(
      id: json['id'],
      titulo: json['titulo'],
      fechaReporte: DateTime.parse(json['fecha_reporte']),
      descripcion: json['descripcion'],
      reportadoPor: json['reportado_por'],
      estado: json['estado'],
      evidencia: json['evidencia'],
      comentarios: json['comentarios'],
    );
  }
}

class ReporteGeneral {
  final int id;
  final String titulo;
  final DateTime fecha;
  final String resumen;
  final String elaboradoPor;
  final String? archivoAdjunto;

  ReporteGeneral({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.resumen,
    required this.elaboradoPor,
    this.archivoAdjunto,
  });

  factory ReporteGeneral.fromJson(Map<String, dynamic> json) {
    return ReporteGeneral(
      id: json['id'],
      titulo: json['titulo'],
      fecha: DateTime.parse(json['fecha']), // Convertir string a DateTime
      resumen: json['resumen'],
      elaboradoPor: json['elaborado_por'],
      archivoAdjunto: json['archivo_adjunto'],
    );
  }
}