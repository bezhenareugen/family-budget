class Budget {
  final String id;
  final String categoryId;
  final double limit;
  final double spent;
  final int month; // 1-12
  final int year;

  const Budget({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.spent,
    required this.month,
    required this.year,
  });

  double get remaining => limit - spent;
  double get percentage => limit > 0 ? (spent / limit).clamp(0.0, 1.5) : 0;
  bool get isOverBudget => spent > limit;

  Budget copyWith({
    String? id,
    String? categoryId,
    double? limit,
    double? spent,
    int? month,
    int? year,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'limit': limit,
        'spent': spent,
        'month': month,
        'year': year,
      };

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        id: json['id'] as String,
        categoryId: json['categoryId'] as String,
        limit: (json['limit'] as num).toDouble(),
        spent: (json['spent'] as num).toDouble(),
        month: json['month'] as int,
        year: json['year'] as int,
      );
}
