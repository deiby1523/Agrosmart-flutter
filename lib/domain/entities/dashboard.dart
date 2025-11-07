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
}

class DashboardMilkTrendByDate {
  final DateTime date;
  final double liters;

  DashboardMilkTrendByDate({
    required this.date,
    required this.liters,
  });
}

class DashboardMilkTrendByLot {
  final int lotId;
  final String lotName;
  final double liters;

  DashboardMilkTrendByLot({
    required this.lotId,
    required this.lotName,
    required this.liters,
  });
}

class DashboardFeedingSummary {
  final double totalFeedQuantityMonthKg;
  final String mostUsedSupplyType;
  final String mostUsedGrassType;
  final String feedingFrequencyDominant;

  DashboardFeedingSummary({
    required this.totalFeedQuantityMonthKg,
    required this.mostUsedSupplyType,
    required this.mostUsedGrassType,
    required this.feedingFrequencyDominant,
  });
}

class DashboardEfficiencyIndicators {
  final double milkPerAnimal;
  final double milkPerLot;
  final double feedEfficiencyRatio;
  final int lotsAboveAverage;

  DashboardEfficiencyIndicators({
    required this.milkPerAnimal,
    required this.milkPerLot,
    required this.feedEfficiencyRatio,
    required this.lotsAboveAverage,
  });
}

class DashboardMetrics {
  final int farmId;
  final String farmName;
  final DateTime generatedAt;
  final DashboardSummary summary;
  final DashboardMilkProduction milkProduction;
  final List<DashboardMilkTrendByDate> milkTrendByDate;
  final List<DashboardMilkTrendByLot> milkTrendByLot;
  final DashboardFeedingSummary feedingSummary;
  final DashboardEfficiencyIndicators efficiencyIndicators;

  DashboardMetrics({
    required this.farmId,
    required this.farmName,
    required this.generatedAt,
    required this.summary,
    required this.milkProduction,
    required this.milkTrendByDate,
    required this.milkTrendByLot,
    required this.feedingSummary,
    required this.efficiencyIndicators,
  });
}
