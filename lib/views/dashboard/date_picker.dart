import 'package:flutter/material.dart';

class CalendarDateRangePicker extends StatelessWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialDateRange;
  final ValueChanged<DateTimeRange?> onChanged;

  const CalendarDateRangePicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    this.initialDateRange,
  });

  @override
  Widget build(BuildContext context) {
    return DateRangePickerDialog(
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: initialDateRange,
    );
  }
}
