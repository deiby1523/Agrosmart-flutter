import 'package:agrosmart_flutter/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class LotTableSkeleton extends StatelessWidget {
  final int rowCount;

  const LotTableSkeleton({super.key, this.rowCount = 10});

  @override
  Widget build(BuildContext context) {
    // Reutilizamos la misma decoración del contenedor principal para mantener consistencia
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(30),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DataTable(
          headingRowHeight: 56,
          dataRowHeight: 64,
          columnSpacing: 24,
          horizontalMargin: 24,
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).cardTheme.color,
          ),
          columns: [
            const DataColumn(label: _HeaderText('NOMBRE')),
            if (MediaQuery.sizeOf(context).width > Responsive.mobileWidth)
              const DataColumn(label: _HeaderText('DESCRIPCIÓN')),
            const DataColumn(label: _HeaderText('ACCIONES')),
          ],
          // Generamos filas ficticias
          rows: List.generate(
            rowCount,
            (index) => DataRow(
              cells: [
                _buildSkeletonCell(width: 10), // Nombre
                if (MediaQuery.sizeOf(context).width > Responsive.mobileWidth)
                  _buildSkeletonCell(width: 190), // Descripcion
                _buildSkeletonCell(width: 80), // Acciones
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataCell _buildSkeletonCell({required double width}) {
    return DataCell(
      Container(
        height: 16,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1), // Color del skeleton
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// Widget auxiliar para mantener el estilo de texto del header constante
class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        letterSpacing: 0.5,
      ),
    );
  }
}
