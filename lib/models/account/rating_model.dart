import 'package:equatable/equatable.dart';

class RatingModel extends Equatable {
  final int total;
  final int average;
  final String totalMarks;
  final int percent;

  const RatingModel({
    required this.total,
    required this.average,
    required this.totalMarks,
    required this.percent,
  });

  const RatingModel.empty()
    : total = 0,
      average = 0,
      totalMarks = '',
      percent = 0;

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      total: json['total'] ?? 0,
      average: json['average'] ?? 0,
      totalMarks: json['total_marks']?.toString() ?? '',
      percent: json['percent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'average': average,
      'total_marks': totalMarks,
      'percent': percent,
    };
  }

  @override
  List<Object?> get props => [total, average, totalMarks, percent];
}
