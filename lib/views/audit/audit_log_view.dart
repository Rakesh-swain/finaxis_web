import 'package:flutter/material.dart';

class AuditLogView extends StatefulWidget {
  const AuditLogView({Key? key}) : super(key: key);

  @override
  State<AuditLogView> createState() => _AuditLogViewState();
}

class _AuditLogViewState extends State<AuditLogView> {
  final _userCtrl = TextEditingController();
  String _action = 'Any';
  DateTimeRange? _range;

  final _rows = List.generate(20, (i) => {
    'time': DateTime.now().subtract(Duration(minutes: i*7)).toString().substring(0, 19),
    'user': 'user${i%4}',
    'action': ['LOGIN','VIEW','EXPORT','UPDATE'][i%4],
    'detail': 'Detail message #$i'
  });

  @override
  void dispose(){ _userCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audit Log')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 220, child: TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'Filter by user'))),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _action,
                  items: const [DropdownMenuItem(value: 'Any', child: Text('Any')), DropdownMenuItem(value: 'LOGIN', child: Text('LOGIN')), DropdownMenuItem(value: 'VIEW', child: Text('VIEW')), DropdownMenuItem(value: 'EXPORT', child: Text('EXPORT')), DropdownMenuItem(value: 'UPDATE', child: Text('UPDATE'))],
                  onChanged: (v){ setState(() { _action = v ?? 'Any'; }); },
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(_range == null ? 'Date Range' : '${_range!.start.toString().substring(0,10)} - ${_range!.end.toString().substring(0,10)}'),
                  onPressed: () async {
                    final now = DateTime.now();
                    final r = await showDateRangePicker(context: context, firstDate: now.subtract(const Duration(days: 365)), lastDate: now);
                    if (r!=null) setState(()=> _range=r);
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.download), label: const Text('Download CSV')),
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
                      DataColumn(label: Text('Timestamp')),
                      DataColumn(label: Text('User')),
                      DataColumn(label: Text('Action')),
                      DataColumn(label: Text('Detail')),
                    ],
                    rows: _rows.where((r){
                      final userOk = _userCtrl.text.isEmpty || r['user']!.contains(_userCtrl.text);
                      final actionOk = _action=='Any' || r['action']==_action;
                      // Date range filter omitted for brevity in demo
                      return userOk && actionOk;
                    }).toList().asMap().entries.map((e){
                      final idx = e.key; final r = e.value;
                      return DataRow(color: MaterialStateProperty.all(idx%2==0? Colors.black.withOpacity(0.02): Colors.transparent), cells: [
                        DataCell(Text(r['time']!)),
                        DataCell(Text(r['user']!)),
                        DataCell(Text(r['action']!)),
                        DataCell(Text(r['detail']!)),
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
