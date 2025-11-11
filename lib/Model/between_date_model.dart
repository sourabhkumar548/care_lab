class BetweenDateModel {
  final String startDate;
  final String endDate;
  final double totalAmount;
  final double totalCollection;
  final double totalDue;
  final int totalPatients;
  final List<PaymentModeWise> paymentModeWise;

  BetweenDateModel({
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.totalCollection,
    required this.totalDue,
    required this.totalPatients,
    required this.paymentModeWise,
  });

  factory BetweenDateModel.fromJson(Map<String, dynamic> json) {
    return BetweenDateModel(
      startDate: json['start_date']?.toString() ?? "",
      endDate: json['end_date']?.toString() ?? "",
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      totalCollection: (json['total_collection'] ?? 0).toDouble(),
      totalDue: (json['total_due'] ?? 0).toDouble(),
      totalPatients: json['total_patients'] ?? 0,
      paymentModeWise: (json['payment_mode_wise'] as List)
          .map((e) => PaymentModeWise.fromJson(e))
          .toList(),
    );
  }
}

class PaymentModeWise {
  final String payMode;
  final double totalCollection;

  PaymentModeWise({
    required this.payMode,
    required this.totalCollection,
  });

  factory PaymentModeWise.fromJson(Map<String, dynamic> json) {
    return PaymentModeWise(
      payMode: json['pay_mode']?.toString() ?? "Unknown",
      totalCollection: (json['total_collection'] ?? 0).toDouble(),
    );
  }
}
