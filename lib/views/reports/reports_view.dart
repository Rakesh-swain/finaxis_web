import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reports = List.generate(8, (i) => {
      'date': DateTime.now().subtract(Duration(days: i)).toString().substring(0,10),
      'type': ['Monthly','Quarterly','Daily'][i%3],
      'size': '${(1.2 + i/10).toStringAsFixed(1)} MB'
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(child: _SummaryCard(title: 'Reports Generated', value: '128', icon: Icons.description)),
                SizedBox(width: 12),
                Expanded(child: _SummaryCard(title: 'Downloads', value: '2,341', icon: Icons.download)),
                SizedBox(width: 12),
                Expanded(child: _SummaryCard(title: 'Failures', value: '3', icon: Icons.error_outline, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.picture_as_pdf), label: const Text('Download PDF')),
                const SizedBox(width: 8),
                ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.table_view), label: const Text('Download CSV')),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.surfaceVariant),
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Size')),
                      DataColumn(label: Text('Download')),
                    ],
                    rows: reports.asMap().entries.map((e){
                      final idx=e.key; final r=e.value;
                      return DataRow(color: MaterialStateProperty.all(idx%2==0? Colors.black.withOpacity(0.02): Colors.transparent), cells: [
                        DataCell(Text(r['date']!)),
                        DataCell(Text(r['type']!)),
                        DataCell(Text(r['size']!)),
                        const DataCell(Icon(Icons.download, color: Colors.blue)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title; final String value; final IconData icon; final Color? color;
  const _SummaryCard({required this.title, required this.value, required this.icon, this.color});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: (color??Colors.indigo).withOpacity(0.12)),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: color??Colors.indigo),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.black54)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ])
          ],
        ),
      ),
    );
  }
}
