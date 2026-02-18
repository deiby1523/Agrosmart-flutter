import 'package:agrosmart_flutter/data/repositories/report_repository_impl.dart';
import 'package:agrosmart_flutter/data/services/files/file_service.dart';
import 'package:agrosmart_flutter/domain/entities/lot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_provider.g.dart';

@riverpod
ReportRepositoryImpl reportRepository(Ref ref) {
  return ReportRepositoryImpl();
}

@riverpod
class Reports extends _$Reports {
  
  @override
  FutureOr<void> build() async {}

  // Ahora el método recibe los datos del formulario
  Future<void> generateProductionReport({
    required List<int> loteIds,
    required DateTime start,
    required DateTime end,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reportRepositoryProvider);
      
      final fileName = "reporte_produccion_${DateTime.now().millisecondsSinceEpoch}.pdf";
      // final savePath = "${dir.path}/$fileName";

      // 2. Llamar al repo
      final bytes =await repository.downloadProductionReport(
        loteIds: loteIds,
        fechaInicio: start,
        fechaFin: end,
      );

      await FileServiceImp().saveAndOpen(bytes, fileName);

    });
  }

  Future<void> generateSupplyReport({
    required String? supplyType,
    required DateTime? start,
    required DateTime? end,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reportRepositoryProvider);
      
      final fileName = "reporte_insumos_${DateTime.now().millisecondsSinceEpoch}.pdf";

      // 2. Llamar al repo
      final bytes = await repository.downloadSupplyReport(
        tipoInsumo: supplyType,
        fechaInicio: start,
        fechaFin: end,
      );

      await FileServiceImp().saveAndOpen(bytes, fileName);
    });
  }

  Future<void> generateAnimalReport({
    required Lot? lot,
    required String? sex,
    required String? status,
    required String? healthStatus,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reportRepositoryProvider);
      
      
      final fileName = "reporte_animales_${DateTime.now().millisecondsSinceEpoch}.pdf";

      // 2. Llamar al repo
      final bytes = await repository.downloadAnimalReport(
        lote: lot,
        sexo: sex,
        estado: status,
        estadoSalud: healthStatus,
      );

      await FileServiceImp().saveAndOpen(bytes, fileName);
    });
  }

  Future<void> generateFeedingReport({
    required Lot? lot,
    required DateTime? start,
    required DateTime? end,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reportRepositoryProvider);
      
      final fileName = "reporte_alimentacion_${DateTime.now().millisecondsSinceEpoch}.pdf";

      // 2. Llamar al repo
      final bytes = await repository.downloadFeedingReport(
        lote: lot,
        fechaInicio: start,
        fechaFin: end,
      );

      await FileServiceImp().saveAndOpen(bytes, fileName);
    });
  }

  Future<void> generatePaddockReport() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reportRepositoryProvider);
      
      final fileName = "reporte_potreros_${DateTime.now().millisecondsSinceEpoch}.pdf";

      // 2. Llamar al repo
      final bytes = await repository.downloadPaddockReport();

      await FileServiceImp().saveAndOpen(bytes, fileName);
    });
  }

  Future<void> generateLotReport() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reportRepositoryProvider);

      final fileName = "reporte_lotes_${DateTime.now().millisecondsSinceEpoch}.pdf";

      // 2. Llamar al repo
      final bytes = await repository.downloadLotReport();

      await FileServiceImp().saveAndOpen(bytes, fileName);
    });
  }


}