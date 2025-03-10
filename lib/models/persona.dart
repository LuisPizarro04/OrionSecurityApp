class PersonaAcceso {
  final int id;
  final String nombre;
  final String identificacion;
  final String tipoPersona;
  final String? empresa;

  PersonaAcceso({
    required this.id,
    required this.nombre,
    required this.identificacion,
    required this.tipoPersona,
    this.empresa,
  });

  factory PersonaAcceso.fromJson(Map<String, dynamic> json) {
    return PersonaAcceso(
      id: json['id'],
      nombre: json['nombre'],
      identificacion: json['identificacion'],
      tipoPersona: json['tipo_persona'],
      empresa: json['empresa'],
    );
  }
}