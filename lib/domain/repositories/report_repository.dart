import 'package:agrosmart_flutter/domain/entities/lot.dart';

abstract class ReportRepository {
  Future<void> downloadProductionReport({
    required List<int> loteIds,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  Future<void> downloadSupplyReport({
    required String tipoInsumo,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  Future<void> downloadAnimalReport({
    required Lot lote,
    required String sexo,
    required String estado,
    required String estadoSalud,
  });

  Future<void> downloadFeedingReport({
    required Lot lote,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  Future<void> downloadPaddockReport();

  Future<void> downloadLotReport();
}
