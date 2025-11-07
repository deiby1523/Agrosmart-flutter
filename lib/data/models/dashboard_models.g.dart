// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dashboard _$DashboardFromJson(Map<String, dynamic> json) => Dashboard(
  farmId: (json['farmId'] as num).toInt(),
  farmName: json['farmName'] as String,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  summary: Summary.fromJson(json['summary'] as Map<String, dynamic>),
  milkProduction: MilkProduction.fromJson(
    json['milkProduction'] as Map<String, dynamic>,
  ),
  milkTrend: MilkTrend.fromJson(json['milkTrend'] as Map<String, dynamic>),
  feedingSummary: FeedingSummary.fromJson(
    json['feedingSummary'] as Map<String, dynamic>,
  ),
  efficiencyIndicators: EfficiencyIndicators.fromJson(
    json['efficiencyIndicators'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DashboardToJson(Dashboard instance) => <String, dynamic>{
  'farmId': instance.farmId,
  'farmName': instance.farmName,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'summary': instance.summary.toJson(),
  'milkProduction': instance.milkProduction.toJson(),
  'milkTrend': instance.milkTrend.toJson(),
  'feedingSummary': instance.feedingSummary.toJson(),
  'efficiencyIndicators': instance.efficiencyIndicators.toJson(),
};

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
  totalAnimals: (json['totalAnimals'] as num).toInt(),
  totalLots: (json['totalLots'] as num).toInt(),
  totalPaddocks: (json['totalPaddocks'] as num).toInt(),
  totalBreeds: (json['totalBreeds'] as num).toInt(),
);

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
  'totalAnimals': instance.totalAnimals,
  'totalLots': instance.totalLots,
  'totalPaddocks': instance.totalPaddocks,
  'totalBreeds': instance.totalBreeds,
};

MilkProduction _$MilkProductionFromJson(Map<String, dynamic> json) =>
    MilkProduction(
      todayLiters: (json['todayLiters'] as num).toDouble(),
      currentMonthLiters: (json['currentMonthLiters'] as num).toDouble(),
      last30RecordsLiters: (json['last30RecordsLiters'] as num).toDouble(),
      monthlyAverageLiters: (json['monthlyAverageLiters'] as num).toDouble(),
      dailyAverageLiters: (json['dailyAverageLiters'] as num).toDouble(),
    );

Map<String, dynamic> _$MilkProductionToJson(MilkProduction instance) =>
    <String, dynamic>{
      'todayLiters': instance.todayLiters,
      'currentMonthLiters': instance.currentMonthLiters,
      'last30RecordsLiters': instance.last30RecordsLiters,
      'monthlyAverageLiters': instance.monthlyAverageLiters,
      'dailyAverageLiters': instance.dailyAverageLiters,
    };

MilkTrend _$MilkTrendFromJson(Map<String, dynamic> json) => MilkTrend(
  byDate: (json['byDate'] as List<dynamic>)
      .map((e) => MilkByDate.fromJson(e as Map<String, dynamic>))
      .toList(),
  byLot: (json['byLot'] as List<dynamic>)
      .map((e) => MilkByLot.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MilkTrendToJson(MilkTrend instance) => <String, dynamic>{
  'byDate': instance.byDate.map((e) => e.toJson()).toList(),
  'byLot': instance.byLot.map((e) => e.toJson()).toList(),
};

MilkByDate _$MilkByDateFromJson(Map<String, dynamic> json) => MilkByDate(
  date: json['date'] as String,
  liters: (json['liters'] as num).toDouble(),
);

Map<String, dynamic> _$MilkByDateToJson(MilkByDate instance) =>
    <String, dynamic>{'date': instance.date, 'liters': instance.liters};

MilkByLot _$MilkByLotFromJson(Map<String, dynamic> json) => MilkByLot(
  lotId: (json['lotId'] as num).toInt(),
  lotName: json['lotName'] as String,
  liters: (json['liters'] as num).toDouble(),
  details: (json['details'] as List<dynamic>)
      .map((e) => MilkRecordDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MilkByLotToJson(MilkByLot instance) => <String, dynamic>{
  'lotId': instance.lotId,
  'lotName': instance.lotName,
  'liters': instance.liters,
  'details': instance.details.map((e) => e.toJson()).toList(),
};

MilkRecordDetail _$MilkRecordDetailFromJson(Map<String, dynamic> json) =>
    MilkRecordDetail(
      id: (json['id'] as num).toInt(),
      milkQuantity: (json['milkQuantity'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      lotId: (json['lotId'] as num).toInt(),
      farmId: (json['farmId'] as num).toInt(),
    );

Map<String, dynamic> _$MilkRecordDetailToJson(MilkRecordDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'milkQuantity': instance.milkQuantity,
      'date': instance.date.toIso8601String(),
      'lotId': instance.lotId,
      'farmId': instance.farmId,
    };

FeedingSummary _$FeedingSummaryFromJson(Map<String, dynamic> json) =>
    FeedingSummary(
      totalFeedQuantityMonthKg: (json['totalFeedQuantityMonthKg'] as num)
          .toDouble(),
      mostUsedSupplyType: json['mostUsedSupplyType'] as String,
      mostUsedGrassType: json['mostUsedGrassType'] as String,
      feedingFrequencyDominant: json['feedingFrequencyDominant'] as String,
    );

Map<String, dynamic> _$FeedingSummaryToJson(FeedingSummary instance) =>
    <String, dynamic>{
      'totalFeedQuantityMonthKg': instance.totalFeedQuantityMonthKg,
      'mostUsedSupplyType': instance.mostUsedSupplyType,
      'mostUsedGrassType': instance.mostUsedGrassType,
      'feedingFrequencyDominant': instance.feedingFrequencyDominant,
    };

EfficiencyIndicators _$EfficiencyIndicatorsFromJson(
  Map<String, dynamic> json,
) => EfficiencyIndicators(
  milkPerAnimal: (json['milkPerAnimal'] as num).toDouble(),
  milkPerLot: (json['milkPerLot'] as num).toDouble(),
  feedEfficiencyRatio: (json['feedEfficiencyRatio'] as num).toDouble(),
  lotsAboveAverage: (json['lotsAboveAverage'] as num).toInt(),
);

Map<String, dynamic> _$EfficiencyIndicatorsToJson(
  EfficiencyIndicators instance,
) => <String, dynamic>{
  'milkPerAnimal': instance.milkPerAnimal,
  'milkPerLot': instance.milkPerLot,
  'feedEfficiencyRatio': instance.feedEfficiencyRatio,
  'lotsAboveAverage': instance.lotsAboveAverage,
};
