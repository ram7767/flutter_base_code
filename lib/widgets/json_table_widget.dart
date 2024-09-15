import 'package:flutter/material.dart';

class JsonTableWidget extends StatelessWidget {
  final Map<String, dynamic> jsonData;

  // ignore: use_key_in_widget_constructors
  const JsonTableWidget({required this.jsonData});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Key',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Value',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: jsonData.entries.map((entry) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(entry.key)), // Display the JSON key
            DataCell(
                Text(entry.value.toString())), // Display the value as a string
          ],
        );
      }).toList(),
    );
  }
}
