import 'persona.dart';

class RegistroAcceso {
  final int id;
  final PersonaAcceso persona;
  final String motivoVisita;
  final String fechaHoraEntrada;

  RegistroAcceso({
    required this.id,
    required this.persona,
    required this.motivoVisita,
    required this.fechaHoraEntrada,
  });

  factory RegistroAcceso.fromJson(Map<String, dynamic> json) {
    return RegistroAcceso(
      id: json['id'],
      persona: PersonaAcceso.fromJson(json['persona']), // 🔹 Convertir JSON a PersonaAcceso
      motivoVisita: json['motivo_visita'],
      fechaHoraEntrada: json['fecha_hora_entrada'],
    );
  }
}