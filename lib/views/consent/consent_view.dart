import 'package:finaxis_web/widgets/animated_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsentView extends StatefulWidget {
  const ConsentView({Key? key}) : super(key: key);

  @override
  State<ConsentView> createState() => _ConsentViewState();
}

class _ConsentViewState extends State<ConsentView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();

  late final AnimationController _chipCtrl;

  final List<Map<String, String>> _consents = [
    {
      'id': 'CNS-1001', 'customer': 'Amit Kumar', 'bank': 'HDFC', 'status': 'Active', 'date': '2025-09-12'
    },
    {
      'id': 'CNS-1000', 'customer': 'Riya Singh', 'bank': 'SBI', 'status': 'Pending', 'date': '2025-09-10'
    },
    {
      'id': 'CNS-0999', 'customer': 'Karan Shah', 'bank': 'ICICI', 'status': 'Revoked', 'date': '2025-09-08'
    },
  ];

  @override
  void initState() {
    super.initState();
    _chipCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _chipCtrl.dispose();
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _bankCtrl.dispose();
    super.dispose();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Active':
        return Colors.green;
      case 'Pending':
        return Colors.amber;
      case 'Revoked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Consent')),
      body: Row(
        children: [
           AnimatedSidebar(
            selectedIndex: 1,
            onItemSelected: (index) {
              switch (index) {
                case 0:
                  Get.offNamed('/dashboard');
                  break;
                case 1:
                  // already on Applicants
                  break;
                case 2:
                  Get.offNamed('/applicants');
                  break;
               
              }
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Create Consent', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameCtrl,
                                    decoration: const InputDecoration(labelText: 'Customer Name'),
                                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _mobileCtrl,
                                    decoration: const InputDecoration(labelText: 'Mobile Number'),
                                    keyboardType: TextInputType.phone,
                                    validator: (v) => v != null && v.length == 10 ? null : 'Enter 10 digit number',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _bankCtrl,
                                    decoration: const InputDecoration(labelText: 'Bank Name'),
                                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      setState(() {
                                        _consents.insert(0, {
                                          'id': 'CNS-${1001 + _consents.length}',
                                          'customer': _nameCtrl.text,
                                          'bank': _bankCtrl.text,
                                          'status': 'Pending',
                                          'date': DateTime.now().toString().substring(0, 10),
                                        });
                                        _nameCtrl.clear();
                                        _mobileCtrl.clear();
                                        _bankCtrl.clear();
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Consent initiated')));
                                    }
                                  },
                                  icon: const Icon(Icons.add_task),
                                  label: const Text('Create'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Recent Consents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          DataTable(
                            columns: const [
                              DataColumn(label: Text('Consent ID')),
                              DataColumn(label: Text('Customer')),
                              DataColumn(label: Text('Bank')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Date')),
                            ],
                            rows: _consents.map((c) {
                              return DataRow(cells: [
                                DataCell(Text(c['id']!)),
                                DataCell(Text(c['customer']!)),
                                DataCell(Text(c['bank']!)),
                                DataCell(AnimatedBuilder(
                                  animation: _chipCtrl,
                                  builder: (context, _) {
                                    final color = _statusColor(c['status']!);
                                    final t = 0.8 + 0.2 * _chipCtrl.value;
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.12 * t),
                                        border: Border.all(color: color.withOpacity(0.4)),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(radius: 4, backgroundColor: color),
                                          const SizedBox(width: 6),
                                          Text(
                                            c['status']!,
                                            style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )),
                                DataCell(Text(c['date']!)),
                              ]);
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
