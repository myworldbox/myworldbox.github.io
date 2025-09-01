import 'package:flutter/material.dart';
import '../../model/model_ui.dart';

class DefaultTable extends StatefulWidget {
  final ModelUi ui;

  const DefaultTable({super.key, required this.ui});

  @override
  State<DefaultTable> createState() => _DefaultTableState();
}

class _DefaultTableState extends State<DefaultTable> {
  int _currentPage = 0;
  final int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final data = widget.ui.data;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (data == null ||
            (data is Map && data.isEmpty) ||
            (data is List && data.isEmpty)) {
          return const Center(child: Text('No data available'));
        }

        final maxRows = data is Map<String, List<String>>
            ? data.values
                  .map((list) => list.length)
                  .reduce((a, b) => a < b ? a : b)
            : (data as List<List<String>>).length;

        final columns = data is Map<String, List<String>>
            ? data.keys.map((key) => DataColumn(label: Text(key))).toList()
            : List.generate(
                (data as List<List<String>>)[0].length,
                (index) => DataColumn(label: Text('Column $index')),
              );

        final totalPages = (maxRows / _rowsPerPage).ceil();
        final startIndex = _currentPage * _rowsPerPage;
        final endIndex = (startIndex + _rowsPerPage) < maxRows
            ? (startIndex + _rowsPerPage)
            : maxRows;

        final rows = List.generate(endIndex - startIndex, (i) {
          final index = startIndex + i;
          return DataRow(
            cells: data is Map<String, List<String>>
                ? (data).keys
                      .map((key) => DataCell(Text(data[key]![index])))
                      .toList()
                : (data as List<List<String>>)[index]
                      .map((cell) => DataCell(Text(cell)))
                      .toList(),
          );
        });

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.9,
              maxHeight: constraints.maxHeight * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: columns,
                        rows: rows,
                        columnSpacing: 50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _currentPage > 0
                          ? () => setState(() => _currentPage--)
                          : null,
                      child: const Text('Previous'),
                    ),
                    const SizedBox(width: 16),
                    Text('Page ${_currentPage + 1} of $totalPages'),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _currentPage < totalPages - 1
                          ? () => setState(() => _currentPage++)
                          : null,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
