import 'package:agrosmart_flutter/domain/entities/lot.dart';

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

  Future<void> downloadAnimalReport({
    required Lot lote,
    required String sexo,
    required String estado,
    required String estadoSalud,
    required String savePath,
  });

  Future<void> downloadFeedingReport({
    required Lot lote,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String savePath,
  });

  Future<void> downloadPaddockReport({required String savePath});

  Future<void> downloadLotReport({required String savePath});
}
