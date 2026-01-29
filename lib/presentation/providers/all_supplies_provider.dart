import 'package:agrosmart_flutter/domain/entities/supply.dart';
import 'package:agrosmart_flutter/presentation/providers/supply_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
Future<List<Supply>> allSupplies(Ref ref) async {
  final repository = ref.read(supplyRepositoryProvider);

  // Solicitamos una página 0 con un tamaño muy grande para traer "todos"
  // O idealmente, tu backend debería tener un endpoint '/all-supplies' sin paginación.
  final response = await repository.getSupplies(page: 0, size: 50); 
  
  // Retornamos la lista pura, no el objeto paginado
  return response.items; // O .items, según tu modelo
}