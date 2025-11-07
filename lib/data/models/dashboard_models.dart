import 'package:json_annotation/json_annotation.dart';

part 'dashboard_models.g.dart';

@JsonSerializable(explicitToJson: true)
class Dashboard {
  final int farmId;
  final String farmName;
  final DateTime generatedAt;
  final Summary summary;
  final MilkProduction milkProduction;
  final MilkTrend milkTrend;
  final FeedingSummary feedingSummary;
  final EfficiencyIndicators efficiencyIndicators;

  Dashboard({
    required this.farmId,
    required this.farmName,
    required this.generatedAt,
    required this.summary,
    required this.milkProduction,
    required this.milkTrend,
    required this.feedingSummary,
    required this.efficiencyIndicators,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) =>
      _$DashboardFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardToJson(this);
}

// summary
@JsonSerializable()
class Summary {
  final int totalAnimals;
  final int totalLots;
  final int totalPaddocks;
  final int totalBreeds;

  Summary({
    required this.totalAnimals,
    required this.totalLots,
    required this.totalPaddocks,
    required this.totalBreeds,
  });

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryToJson(this);
}

// milkProduction
@JsonSerializable()
class MilkProduction {
  final double todayLiters;
  final double currentMonthLiters;
  final double last30RecordsLiters;
  final double monthlyAverageLiters;
  final double dailyAverageLiters;

  MilkProduction({
    required this.todayLiters,
    required this.currentMonthLiters,
    required this.last30RecordsLiters,
    required this.monthlyAverageLiters,
    required this.dailyAverageLiters,
  });

  factory MilkProduction.fromJson(Map<String, dynamic> json) =>
      _$MilkProductionFromJson(json);
  Map<String, dynamic> toJson() => _$MilkProductionToJson(this);
}

// milkTrend
@JsonSerializable(explicitToJson: true)
class MilkTrend {
  final List<MilkByDate> byDate;
  final List<MilkByLot> byLot;

  MilkTrend({
    required this.byDate,
    required this.byLot,
  });

  factory MilkTrend.fromJson(Map<String, dynamic> json) =>
      _$MilkTrendFromJson(json);
  Map<String, dynamic> toJson() => _$MilkTrendToJson(this);
}

@JsonSerializable()
class MilkByDate {
  final String date;
  final double liters;

  MilkByDate({
    required this.date,
    required this.liters,
  });

  factory MilkByDate.fromJson(Map<String, dynamic> json) =>
      _$MilkByDateFromJson(json);
  Map<String, dynamic> toJson() => _$MilkByDateToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MilkByLot {
  final int lotId;
  final String lotName;
  final double liters;
  final List<MilkRecordDetail> details;

  MilkByLot({
    required this.lotId,
    required this.lotName,
    required this.liters,
    required this.details,
  });

  factory MilkByLot.fromJson(Map<String, dynamic> json) =>
      _$MilkByLotFromJson(json);
  Map<String, dynamic> toJson() => _$MilkByLotToJson(this);
}

@JsonSerializable()
class MilkRecordDetail {
  final int id;
  final double milkQuantity;
  final DateTime date;
  final int lotId;
  final int farmId;

  MilkRecordDetail({
    required this.id,
    required this.milkQuantity,
    required this.date,
    required this.lotId,
    required this.farmId,
  });

  factory MilkRecordDetail.fromJson(Map<String, dynamic> json) =>
      _$MilkRecordDetailFromJson(json);
  Map<String, dynamic> toJson() => _$MilkRecordDetailToJson(this);
}

// feedingSummary
@JsonSerializable()
class FeedingSummary {
  final double totalFeedQuantityMonthKg;
  final String mostUsedSupplyType;
  final String mostUsedGrassType;
  final String feedingFrequencyDominant;

  FeedingSummary({
    required this.totalFeedQuantityMonthKg,
    required this.mostUsedSupplyType,
    required this.mostUsedGrassType,
    required this.feedingFrequencyDominant,
  });

  factory FeedingSummary.fromJson(Map<String, dynamic> json) =>
      _$FeedingSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$FeedingSummaryToJson(this);
}

// efficiencyIndicators
@JsonSerializable()
class EfficiencyIndicators {
  final double milkPerAnimal;
  final double milkPerLot;
  final double feedEfficiencyRatio;
  final int lotsAboveAverage;

  EfficiencyIndicators({
    required this.milkPerAnimal,
    required this.milkPerLot,
    required this.feedEfficiencyRatio,
    required this.lotsAboveAverage,
  });

  factory EfficiencyIndicators.fromJson(Map<String, dynamic> json) =>
      _$EfficiencyIndicatorsFromJson(json);
  Map<String, dynamic> toJson() => _$EfficiencyIndicatorsToJson(this);
}
