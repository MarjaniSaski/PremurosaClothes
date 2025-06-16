class Voucher {
  final int? id;
  final String voucherName;
  final String voucherCode;
  final double discount;
  final int points;
  final DateTime usagePeriod;
  final DateTime maxPeriod;
  final int usageQuota;
  final double maxAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Voucher({
    this.id,
    required this.voucherName,
    required this.voucherCode,
    required this.discount,
    required this.points,
    required this.usagePeriod,
    required this.maxPeriod,
    required this.usageQuota,
    required this.maxAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'],
      voucherName: json['voucher_name'] ?? '',
      voucherCode: json['voucher_code'] ?? '',
      discount: json['discount'] ?? 0,
      points: json['points'] ?? 0,
      usagePeriod: DateTime.parse(json['usage_period']),
      maxPeriod: DateTime.parse(json['max_period']),
      usageQuota: json['usage_quota'] ?? 0,
      maxAmount: json['max_amount'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'voucher_name': voucherName,
      'voucher_code': voucherCode,
      'discount': discount,
      'points': points,
      'usage_period': usagePeriod.toIso8601String(),
      'max_period': maxPeriod.toIso8601String(),
      'usage_quota': usageQuota,
      'max_amount': maxAmount,
    };
  }

  // Convert from your current Map format
  factory Voucher.fromMap(Map<String, dynamic> map) {
    return Voucher(
      voucherName: map['voucher_name'] ?? '',
      voucherCode: map['voucher_code'] ?? '',
      discount: map['discount'] ?? 0,
      points: map['points'] ?? 0,
      usagePeriod: DateTime.parse(map['usage_period']),
      maxPeriod: DateTime.parse(map['max_period']),
      usageQuota: map['usage_quota'] ?? 0,
      maxAmount: map['max_amount'] ?? 0,
    );
  }

  bool? get isActive => null;

  // Convert to your current Map format
  Map<String, dynamic> toMap() {
    return {
      'voucher_name': voucherName,
      'voucher_code': voucherCode,
      'discount': discount,
      'points': points,
      'usage_period': usagePeriod.toString().substring(0, 16),
      'max_period': maxPeriod.toString().substring(0, 16),
      'usage_quota': usageQuota,
      'max_amount': maxAmount,
    };
  }
}