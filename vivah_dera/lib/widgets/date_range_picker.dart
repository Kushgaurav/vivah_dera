import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime)? onStartDateChanged;
  final Function(DateTime)? onEndDateChanged;
  final Function(DateTime, DateTime)? onDateRangeSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<DateTime>? disabledDates;
  final String? title;

  const DateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.onDateRangeSelected,
    this.firstDate,
    this.lastDate,
    this.disabledDates,
    this.title,
  });

  @override
  State<DateRangePicker> createState() => DateRangePickerState();
}

class DateRangePickerState extends State<DateRangePicker> {
  DateTimeRange? _selectedDateRange;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    DateTime start = widget.startDate ?? DateTime.now();
    DateTime end =
        widget.endDate ?? DateTime.now().add(const Duration(days: 1));
    _selectedDateRange = DateTimeRange(start: start, end: end);
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: widget.firstDate ?? DateTime.now(),
      lastDate:
          widget.lastDate ?? DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return; // Add mounted check before using context

    if (picked != null) {
      // Validate the selected dates
      if (widget.disabledDates != null) {
        final DateTime start = picked.start;
        final DateTime end = picked.end;

        // Check each day in the range
        for (int i = 0; i <= end.difference(start).inDays; i++) {
          final DateTime currentDate = start.add(Duration(days: i));
          if (!_isDateSelectable(currentDate)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selected range contains unavailable dates'),
              ),
            );
            return;
          }
        }
      }

      setState(() {
        _selectedDateRange = picked;
      });

      // Call all the appropriate callbacks
      if (widget.onStartDateChanged != null) {
        widget.onStartDateChanged!(picked.start);
      }

      if (widget.onEndDateChanged != null) {
        widget.onEndDateChanged!(picked.end);
      }

      if (widget.onDateRangeSelected != null) {
        widget.onDateRangeSelected!(picked.start, picked.end);
      }
    }
  }

  bool _isDateSelectable(DateTime day) {
    if (widget.disabledDates != null) {
      return !widget.disabledDates!.any(
        (DateTime disabledDate) =>
            day.year == disabledDate.year &&
            day.month == disabledDate.month &&
            day.day == disabledDate.day,
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Use widget.startDate and widget.endDate if available, otherwise use _selectedDateRange
    DateTime start = widget.startDate ?? _selectedDateRange!.start;
    DateTime end = widget.endDate ?? _selectedDateRange!.end;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.title!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        InkWell(
          onTap: _selectDateRange,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_dateFormat.format(start)} - ${_dateFormat.format(end)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Duration: ',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            Text(
              '${end.difference(start).inDays + 1} days',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
