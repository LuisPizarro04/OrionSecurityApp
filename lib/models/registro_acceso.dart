class RegistroAcceso {
  final int id;
  final String motivoVisita;
  final String comentario;
  final String fechaHoraEntrada;
  final String? fechaHoraSalida;

  RegistroAcceso({
    required this.id,
    required this.motivoVisita,
    required this.comentario,
    required this.fechaHoraEntrada,
    this.fechaHoraSalida,
  });

  factory RegistroAcceso.fromJson(Map<String, dynamic> json) {
    return RegistroAcceso(
      id: json['id'],
      motivoVisita: json['motivo_visita'],
      comentario: json['comentario'],
      fechaHoraEntrada: json['fecha_hora_entrada'],
      fechaHoraSalida: json['fecha_hora_salida'],
    );
  }
}