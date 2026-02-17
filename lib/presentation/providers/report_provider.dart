import 'package:agrosmart_flutter/data/repositories/report_repository_impl.dart';
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
      
      // 1. Definir nombre y ruta del archivo
      final dir = await getApplicationDocumentsDirectory();
      // Tip: Usar fecha en el nombre para no sobrescribir siempre el mismo
      final fileName = "reporte_produccion_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final savePath = "${dir.path}/$fileName";

      // 2. Llamar al repo
      await repository.downloadProductionReport(
        loteIds: loteIds,
        fechaInicio: start,
        fechaFin: end,
        savePath: savePath,
      );

      // 3. Abrir
      await OpenFile.open(savePath);
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
      
      // 1. Definir nombre y ruta del archivo
      final dir = await getApplicationDocumentsDirectory();
      // Tip: Usar fecha en el nombre para no sobrescribir siempre el mismo
      final fileName = "reporte_insumos_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final savePath = "${dir.path}/$fileName";

      // 2. Llamar al repo
      await repository.downloadSupplyReport(
        tipoInsumo: supplyType,
        fechaInicio: start,
        fechaFin: end,
        savePath: savePath,
      );

      // 3. Abrir
      await OpenFile.open(savePath);
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
      
      // 1. Definir nombre y ruta del archivo
      final dir = await getApplicationDocumentsDirectory();
      // Tip: Usar fecha en el nombre para no sobrescribir siempre el mismo
      final fileName = "reporte_animales_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final savePath = "${dir.path}/$fileName";

      // 2. Llamar al repo
      await repository.downloadAnimalReport(
        lote: lot,
        sexo: sex,
        estado: status,
        estadoSalud: healthStatus,
        savePath: savePath,
      );

      // 3. Abrir
      await OpenFile.open(savePath);
    });
  }


}