class DashboardSummary {
  final int totalAnimals;
  final int totalLots;
  final int totalPaddocks;
  final int totalBreeds;

  DashboardSummary({
    required this.totalAnimals,
    required this.totalLots,
    required this.totalPaddocks,
    required this.totalBreeds,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalAnimals: json['totalAnimals'] ?? 0,
      totalLots: json['totalLots'] ?? 0,
      totalPaddocks: json['totalPaddocks'] ?? 0,
      totalBreeds: json['totalBreeds'] ?? 0,
    );
  }
}

class DashboardMilkProduction {
  final double todayLiters;
  final double currentMonthLiters;
  final double last30RecordsLiters;
  final double monthlyAverageLiters;
  final double dailyAverageLiters;

  DashboardMilkProduction({
    required this.todayLiters,
    required this.currentMonthLiters,
    required this.last30RecordsLiters,
    required this.monthlyAverageLiters,
    required this.dailyAverageLiters,
  });

  factory DashboardMilkProduction.fromJson(Map<String, dynamic> json) {
    return DashboardMilkProduction(
      todayLiters: (json['todayLiters'] as num).toDouble(),
      currentMonthLiters: (json['currentMonthLiters'] as num).toDouble(),
      last30RecordsLiters: (json['last30RecordsLiters'] as num).toDouble(),
      monthlyAverageLiters: (json['monthlyAverageLiters'] as num).toDouble(),
      dailyAverageLiters: (json['dailyAverageLiters'] as num).toDouble(),
    );
  }
}

class DashboardMilkTrendByDate {
  final DateTime date;
  final double liters;

  DashboardMilkTrendByDate({
    required this.date,
    required this.liters,
  });

  factory DashboardMilkTrendByDate.fromJson(Map<String, dynamic> json) {
    return DashboardMilkTrendByDate(
      date: DateTime.parse(json['date']),
      liters: (json['liters'] as num).toDouble(),
    );
  }
}

// Nueva clase para los detalles dentro del lote
class MilkLotDetail {
  final int id;
  final double milkQuantity;
  final DateTime date;
  final int lotId;
  final int farmId;

  MilkLotDetail({
    required this.id,
    required this.milkQuantity,
    required this.date,
    required this.lotId,
    required this.farmId,
  });

  factory MilkLotDetail.fromJson(Map<String, dynamic> json) {
    return MilkLotDetail(
      id: json['id'],
      milkQuantity: (json['milkQuantity'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      lotId: json['lotId'],
      farmId: json['farmId'],
    );
  }
}

class DashboardMilkTrendByLot {
  final int lotId;
  final String lotName;
  final double liters;
  final List<MilkLotDetail> details; // Agregado según el JSON

  DashboardMilkTrendByLot({
    required this.lotId,
    required this.lotName,
    required this.liters,
    required this.details,
  });

  factory DashboardMilkTrendByLot.fromJson(Map<String, dynamic> json) {
    return DashboardMilkTrendByLot(
      lotId: json['lotId'],
      lotName: json['lotName'],
      liters: (json['liters'] as num).toDouble(),
      details: (json['details'] as List)
          .map((i) => MilkLotDetail.fromJson(i))
          .toList(),
    );
  }
}

// Nueva clase contenedora para la sección "milkTrend"
class DashboardMilkTrend {
  final List<DashboardMilkTrendByDate> byDate;
  final List<DashboardMilkTrendByLot> byLot;

  DashboardMilkTrend({
    required this.byDate,
    required this.byLot,
  });

  factory DashboardMilkTrend.fromJson(Map<String, dynamic> json) {
    return DashboardMilkTrend(
      byDate: (json['byDate'] as List)
          .map((i) => DashboardMilkTrendByDate.fromJson(i))
          .toList(),
      byLot: (json['byLot'] as List)
          .map((i) => DashboardMilkTrendByLot.fromJson(i))
          .toList(),
    );
  }
}

class DashboardFeedingSummary {
  final int suppliesExpiringSoonCount; // Cambiado: totalFeedQuantityMonthKg no existe en JSON
  final String mostUsedSupplyType;
  final String mostUsedGrassType;
  final String feedingFrequencyDominant;

  DashboardFeedingSummary({
    required this.suppliesExpiringSoonCount,
    required this.mostUsedSupplyType,
    required this.mostUsedGrassType,
    required this.feedingFrequencyDominant,
  });

  factory DashboardFeedingSummary.fromJson(Map<String, dynamic> json) {
    return DashboardFeedingSummary(
      suppliesExpiringSoonCount: json['suppliesExpiringSoonCount'] ?? 0,
      mostUsedSupplyType: json['mostUsedSupplyType'] ?? '',
      mostUsedGrassType: json['mostUsedGrassType'] ?? '',
      feedingFrequencyDominant: json['feedingFrequencyDominant'] ?? '',
    );
  }
}

// Nueva clase para el pico de producción
class PeakProductionDay {
  final DateTime date;
  final double liters;

  PeakProductionDay({
    required this.date,
    required this.liters,
  });

  factory PeakProductionDay.fromJson(Map<String, dynamic> json) {
    return PeakProductionDay(
      date: DateTime.parse(json['date']),
      liters: (json['liters'] as num).toDouble(),
    );
  }
}

class DashboardEfficiencyIndicators {
  final double milkPerAnimal;
  final double milkPerLot;
  final double productionGrowthRate; // Nuevo campo
  final PeakProductionDay peakProductionDay; // Nuevo objeto

  // Eliminados: feedEfficiencyRatio y lotsAboveAverage (no vienen en el JSON)

  DashboardEfficiencyIndicators({
    required this.milkPerAnimal,
    required this.milkPerLot,
    required this.productionGrowthRate,
    required this.peakProductionDay,
  });

  factory DashboardEfficiencyIndicators.fromJson(Map<String, dynamic> json) {
    return DashboardEfficiencyIndicators(
      milkPerAnimal: (json['milkPerAnimal'] as num).toDouble(),
      milkPerLot: (json['milkPerLot'] as num).toDouble(),
      productionGrowthRate: (json['productionGrowthRate'] as num).toDouble(),
      peakProductionDay: PeakProductionDay.fromJson(json['peakProductionDay']),
    );
  }
}

class DashboardMetrics {
  final int farmId;
  final String farmName;
  final DateTime generatedAt;
  final DashboardSummary summary;
  final DashboardMilkProduction milkProduction;
  final DashboardMilkTrend milkTrend; // Agrupado en un solo objeto
  final DashboardFeedingSummary feedingSummary;
  final DashboardEfficiencyIndicators efficiencyIndicators;

  DashboardMetrics({
    required this.farmId,
    required this.farmName,
    required this.generatedAt,
    required this.summary,
    required this.milkProduction,
    required this.milkTrend,
    required this.feedingSummary,
    required this.efficiencyIndicators,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      farmId: json['farmId'],
      farmName: json['farmName'],
      generatedAt: DateTime.parse(json['generatedAt']),
      summary: DashboardSummary.fromJson(json['summary']),
      milkProduction: DashboardMilkProduction.fromJson(json['milkProduction']),
      milkTrend: DashboardMilkTrend.fromJson(json['milkTrend']),
      feedingSummary: DashboardFeedingSummary.fromJson(json['feedingSummary']),
      efficiencyIndicators: DashboardEfficiencyIndicators.fromJson(json['efficiencyIndicators']),
    );
  }
}