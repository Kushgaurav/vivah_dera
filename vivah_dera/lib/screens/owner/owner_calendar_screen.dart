import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class OwnerCalendarScreen extends StatefulWidget {
  const OwnerCalendarScreen({super.key});

  @override
  State<OwnerCalendarScreen> createState() => _OwnerCalendarScreenState();
}

class _OwnerCalendarScreenState extends State<OwnerCalendarScreen> {
  bool _isLoading = true;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedProperty = 'Royal Wedding Hall';
  Map<DateTime, List<Event>> _events = {};
  List<String> _properties = [];
  List<Event> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Simulate loading data from API
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      // Mock properties
      final properties = [
        'Royal Wedding Hall',
        'Garden Party Venue',
        'Conference Center',
      ];

      // Mock events
      final Map<DateTime, List<Event>> events = {};

      // Add some bookings
      _addEvent(
        events,
        DateTime.now().add(const Duration(days: 2)),
        'Booking',
        'Rahul Sharma',
        EventType.booking,
      );
      _addEvent(
        events,
        DateTime.now().add(const Duration(days: 2, hours: 5)),
        'Booking',
        'Amit Kumar',
        EventType.booking,
      );
      _addEvent(
        events,
        DateTime.now().add(const Duration(days: 5)),
        'Booking',
        'Priya Patel',
        EventType.booking,
      );
      _addEvent(
        events,
        DateTime.now().add(const Duration(days: 12)),
        'Booking',
        'Neha Gupta',
        EventType.booking,
      );
      _addEvent(
        events,
        DateTime.now().add(const Duration(days: 20)),
        'Booking',
        'Vikram Singh',
        EventType.booking,
      );

      // Add some blocked dates
      _addEvent(
        events,
        DateTime.now().add(const Duration(days: 8)),
        'Blocked',
        'Maintenance',
        EventType.blocked,
      );
      _addEvent(
        events,
        DateTime.now().add(const Duration(days: 9)),
        'Blocked',
        'Maintenance',
        EventType.blocked,
      );
      _addEvent(
        events,
        DateTime.now().add(const Duration(days: 15)),
        'Blocked',
        'Private Event',
        EventType.blocked,
      );

      setState(() {
        _properties = properties;
        _events = events;
        _isLoading = false;
      });

      // Set selected events if today has events
      _updateSelectedEvents(_focusedDay);
    });
  }

  void _addEvent(
    Map<DateTime, List<Event>> events,
    DateTime date,
    String title,
    String subtitle,
    EventType type,
  ) {
    final day = DateTime(date.year, date.month, date.day);
    if (events[day] == null) {
      events[day] = [];
    }
    events[day]!.add(
      Event(title: title, subtitle: subtitle, time: date, type: type),
    );
  }

  void _updateSelectedEvents(DateTime day) {
    final selectedDay = DateTime(day.year, day.month, day.day);
    setState(() {
      _selectedDay = selectedDay;
      _selectedEvents = _events[selectedDay] ?? [];
    });
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.booking:
        return Colors.blue;
      case EventType.blocked:
        return Colors.red;
    }
  }

  void _showAddEventDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => _BlockDateBottomSheet(
            date: _selectedDay ?? _focusedDay,
            onSave: (reason, startDate, endDate) {
              // In a real app, save to database
              setState(() {
                for (
                  DateTime date = startDate;
                  date.isBefore(endDate.add(const Duration(days: 1)));
                  date = date.add(const Duration(days: 1))
                ) {
                  _addEvent(
                    _events,
                    date,
                    'Blocked',
                    reason,
                    EventType.blocked,
                  );
                }
              });
              _updateSelectedEvents(_selectedDay ?? _focusedDay);
            },
          ),
    );
  }

  void _showEventDetailsDialog(Event event) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              event.type == EventType.booking
                  ? 'Booking Details'
                  : 'Blocked Date',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${_formatDate(event.time)}'),
                if (event.time.hour > 0 || event.time.minute > 0)
                  Text('Time: ${_formatTime(event.time)}'),
                const SizedBox(height: 8),
                Text(
                  '${event.type == EventType.booking ? 'Customer' : 'Reason'}: ${event.subtitle}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              if (event.type == EventType.blocked)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _unblockDate(event);
                  },
                  child: const Text(
                    'Unblock Date',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (event.type == EventType.booking)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Redirecting to booking details...'),
                      ),
                    );
                  },
                  child: const Text('View Details'),
                ),
            ],
          ),
    );
  }

  void _unblockDate(Event event) {
    final day = DateTime(event.time.year, event.time.month, event.time.day);
    setState(() {
      if (_events.containsKey(day)) {
        _events[day] = _events[day]!.where((e) => e != event).toList();
        if (_events[day]!.isEmpty) {
          _events.remove(day);
        }
      }
      _updateSelectedEvents(_selectedDay ?? _focusedDay);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Date unblocked: ${_formatDate(day)}')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter functionality
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Property selector
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Property',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      value: _selectedProperty,
                      items:
                          _properties.map((property) {
                            return DropdownMenuItem(
                              value: property,
                              child: Text(property),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProperty = value!;
                          // In a real app, this would reload events for the selected property
                        });
                      },
                    ),
                  ),

                  // Calendar
                  TableCalendar(
                    firstDay: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    eventLoader: (day) {
                      return _events[DateTime(day.year, day.month, day.day)] ??
                          [];
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      _updateSelectedEvents(selectedDay);
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      markersMaxCount: 3,
                      markersAnchor: 0.7,
                      markerDecoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isEmpty) return null;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              events.take(3).map((event) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1.0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getEventColor(
                                      (event as Event).type,
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ),

                  const Divider(),

                  // Legend
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(Colors.blue, 'Bookings'),
                        const SizedBox(width: 24),
                        _buildLegendItem(Colors.red, 'Blocked Dates'),
                      ],
                    ),
                  ),

                  const Divider(),

                  // Selected day events
                  Expanded(
                    child:
                        _selectedEvents.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _selectedDay != null
                                        ? 'No events on ${_formatDate(_selectedDay!)}'
                                        : 'Select a date to view events',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  if (_selectedDay != null)
                                    ElevatedButton.icon(
                                      onPressed: _showAddEventDialog,
                                      icon: const Icon(Icons.block),
                                      label: const Text('Block This Date'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount:
                                  _selectedEvents.length +
                                  1, // +1 for the date header
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  // Date header
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Events on ${_formatDate(_selectedDay!)}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextButton.icon(
                                          icon: const Icon(Icons.add),
                                          label: const Text('Block Date'),
                                          onPressed: _showAddEventDialog,
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final event = _selectedEvents[index - 1];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: _getEventColor(
                                        event.type,
                                      ).withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: _getEventColor(
                                        event.type,
                                      ).withOpacity(0.2),
                                      child: Icon(
                                        event.type == EventType.booking
                                            ? Icons.calendar_today
                                            : Icons.block,
                                        color: _getEventColor(event.type),
                                      ),
                                    ),
                                    title: Text(event.title),
                                    subtitle: Text(event.subtitle),
                                    onTap: () => _showEventDetailsDialog(event),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
      floatingActionButton:
          _isLoading
              ? null
              : FloatingActionButton(
                onPressed: _showAddEventDialog,
                backgroundColor: Colors.red,
                child: const Icon(Icons.block),
              ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

enum EventType { booking, blocked }

class Event {
  final String title;
  final String subtitle;
  final DateTime time;
  final EventType type;

  Event({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
  });
}

class _BlockDateBottomSheet extends StatefulWidget {
  final DateTime date;
  final Function(String reason, DateTime startDate, DateTime endDate) onSave;

  const _BlockDateBottomSheet({required this.date, required this.onSave});

  @override
  State<_BlockDateBottomSheet> createState() => _BlockDateBottomSheetState();
}

class _BlockDateBottomSheetState extends State<_BlockDateBottomSheet> {
  final _reasonController = TextEditingController();
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.date;
    _endDate = widget.date;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_startDate) ? _startDate : _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardSpace),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Block Date(s)',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Select date range
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _selectStartDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(_startDate)),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: _selectEndDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(_endDate)),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Reason field
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Reason for Blocking',
              hintText: 'e.g., Maintenance, Private Event, etc.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                if (_reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a reason')),
                  );
                  return;
                }
                widget.onSave(_reasonController.text, _startDate, _endDate);
                Navigator.of(context).pop();
              },
              child: Text(
                _startDate == _endDate
                    ? 'Block Date'
                    : 'Block ${_endDate.difference(_startDate).inDays + 1} Days',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
