class Novedad {
  final int id;
  final String descripcion;
  final String fecha;
  final String reportadoPor;

  Novedad({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.reportadoPor,
  });

  factory Novedad.fromJson(Map<String, dynamic> json) {
    return Novedad(
      id: json['id'],
      descripcion: json.containsKey('resumen') ? json['resumen'] : json['descripcion'],
      fecha: json['fecha'] ?? '',
      reportadoPor: json.containsKey('elaborado_por') ? json['elaborado_por'] : json['reportado_por'],
    );
  }
}