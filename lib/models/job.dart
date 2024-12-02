class Job {
  final String id;
  final String client_name;
  final String description;
  final String phone_number;
  final double advance;
  final double service_cost;
  final double remaining;
  final String review_date;
  final String photo;
  final String received_date;
  final String status;

  Job({
    required this.id,
    required this.client_name,
    required this.description,
    required this.phone_number,
    required this.advance,
    required this.service_cost,
    required this.remaining,
    required this.review_date,
    required this.photo,
    required this.received_date,
    required this.status,
  });

  factory Job.fromMap(Map<String, dynamic> data, String id) {
    return Job(
      id: id,
      client_name: data['client_name'] ?? '',
      description: data['description'] ?? '',
      phone_number: data['phone_number'] ?? '',
      advance: data['advance']?.toDouble() ?? 0.0,
      service_cost: data['service_cost']?.toDouble() ?? 0.0,
      remaining: data['remaining']?.toDouble() ?? 0.0,
      review_date: data['review_date'] ?? '',
      photo: data['photo'] ?? '',
      received_date: data['received_date'] ?? '',
      status: data['status'] ?? 'En espera',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'client_name': client_name,
      'description': description,
      'phone_number': phone_number,
      'advance': advance,
      'service_cost': service_cost,
      'remaining': remaining,
      'review_date': review_date,
      'photo': photo,
      'received_date': received_date,
      'status': status,
    };
  }
}
