class RegistroVehiculo {
  final int id;
  final String motivoVisita;
  final String comentario;
  final String patente;
  final String tipoVehiculo;
  final String fechaHoraEntrada;
  final String? fechaHoraSalida;

  RegistroVehiculo({
    required this.id,
    required this.motivoVisita,
    required this.comentario,
    required this.patente,
    required this.tipoVehiculo,
    required this.fechaHoraEntrada,
    this.fechaHoraSalida,
  });

  factory RegistroVehiculo.fromJson(Map<String, dynamic> json) {
    return RegistroVehiculo(
      id: json['id'],
      motivoVisita: json['motivo_visita'],
      comentario: json['comentario'],
      patente: json['patente'],
      tipoVehiculo: json['tipo_vehiculo'],
      fechaHoraEntrada: json['fecha_hora_entrada'],
      fechaHoraSalida: json['fecha_hora_salida'],
    );
  }
}