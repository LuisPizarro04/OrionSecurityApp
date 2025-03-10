class RegistroVehiculo {
  final int id;
  final String persona;
  final String? empresa;
  final String motivoVisita;
  final String patente;
  final String tipoVehiculo;
  final String fechaHoraEntrada;
  final String? fechaHoraSalida;
  final String? autorizadoPor;
  final String comentario;

  RegistroVehiculo({
    required this.id,
    required this.persona,
    this.empresa,
    required this.motivoVisita,
    required this.patente,
    required this.tipoVehiculo,
    required this.fechaHoraEntrada,
    this.fechaHoraSalida,
    this.autorizadoPor,
    required this.comentario,
  });

  factory RegistroVehiculo.fromJson(Map<String, dynamic> json) {
    return RegistroVehiculo(
      id: json['id'],
      persona: json['persona'],
      empresa: json['empresa'],
      motivoVisita: json['motivo_visita'],
      patente: json['patente'],
      tipoVehiculo: json['tipo_vehiculo'],
      fechaHoraEntrada: json['fecha_hora_entrada'],
      fechaHoraSalida: json['fecha_hora_salida'],
      autorizadoPor: json['autorizado_por'],
      comentario: json['comentario'],
    );
  }
}