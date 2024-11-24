class Job {
  final String id;
  final String clientName;
  final String description;
  final String phoneNumber;
  final double advance;
  final double serviceCost;
  final double remaining;
  final String date;
  final String? photo;

  Job({
    required this.id,
    required this.clientName,
    required this.description,
    required this.phoneNumber,
    required this.advance,
    required this.serviceCost,
    required this.remaining,
    required this.date,
    this.photo,
  });

  // Convertir un mapa de datos de Firestore a un objeto Job
  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    return Job(
      id: documentId,
      clientName: data['client_name'],
      description: data['description'],
      phoneNumber: data['phone_number'],
      advance: data['advance'].toDouble(),
      serviceCost: data['service_cost'].toDouble(),
      remaining: data['remaining'].toDouble(),
      date: data['date'],
      photo: data['photo'],
    );
  }

  // Convertir un objeto Job a un mapa de datos para Firestore
  Map<String, dynamic> toMap() {
    return {
      'client_name': clientName,
      'description': description,
      'phone_number': phoneNumber,
      'advance': advance,
      'service_cost': serviceCost,
      'remaining': remaining,
      'date': date,
      'photo': photo,
    };
  }
}
