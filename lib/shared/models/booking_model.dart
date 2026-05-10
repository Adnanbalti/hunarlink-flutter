class BookingModel {
  final String id;
  final UserModel consumer;
  final ProviderModel provider;
  final String scheduledAt;
  final String status;
  final double totalAmount;

  BookingModel({
    required this.id,
    required this.consumer,
    required this.provider,
    required this.scheduledAt,
    required this.status,
    required this.totalAmount,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json['id'],
    consumer: UserModel.fromJson(json['consumer']),
    provider: ProviderModel.fromJson(json['provider']),
    scheduledAt: json['scheduledAt'] ?? '',
    status: json['status'] ?? '',
    totalAmount: (json['totalAmount'] ?? 0).toDouble(),
  );
}