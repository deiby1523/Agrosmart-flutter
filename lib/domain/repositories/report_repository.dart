abstract class ReportRepository {

  Future<void> downloadProductionReport({
    required List<int> loteIds,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String savePath,
  });

  Future<void> downloadSupplyReport({
    required String tipoInsumo,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String savePath,
  });

  // downloadAnimalReport

  // downloadFeedingReport
  
  // etc...

}