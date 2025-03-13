import 'package:flutter/material.dart';
import 'package:vivah_dera/screens/renter/booking_confirmation_screen.dart';

class BookingScreen extends StatefulWidget {
  final String listingId;
  final String listingTitle;
  final String listingImage;
  final String price;

  const BookingScreen({
    super.key,
    required this.listingId,
    required this.listingTitle,
    required this.listingImage,
    required this.price,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final List<String> _steps = ['Dates', 'Details', 'Payment'];

  // Date selection
  DateTime? _startDate;
  DateTime? _endDate;

  // Guest details
  final _guestNameController = TextEditingController();
  final _guestPhoneController = TextEditingController();
  final _guestCountController = TextEditingController(text: '100');
  String? _eventType;
  final _notesController = TextEditingController();

  // Payment
  String _paymentMethod = 'card';
  bool _isProcessing = false;

  final List<String> _eventTypes = [
    'Wedding',
    'Birthday Party',
    'Corporate Event',
    'Conference',
    'Anniversary',
    'Other',
  ];

  @override
  void dispose() {
    _guestNameController.dispose();
    _guestPhoneController.dispose();
    _guestCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectDateRange() async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().add(const Duration(days: 1)),
      end: DateTime.now().add(const Duration(days: 2)),
    );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange:
          _startDate != null && _endDate != null
              ? DateTimeRange(start: _startDate!, end: _endDate!)
              : initialDateRange,
    );

    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
      });
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your booking dates'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    if (_currentStep == 1) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _processBooking();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _processBooking() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => BookingConfirmationScreen(
                bookingId:
                    'B${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                listingTitle: widget.listingTitle,
                listingImage: widget.listingImage,
                startDate: _startDate!,
                endDate: _endDate!,
                totalAmount: _calculateTotal(),
                guestCount: int.parse(_guestCountController.text),
              ),
        ),
      );
    });
  }

  String _calculateTotal() {
    if (_startDate == null || _endDate == null) {
      return widget.price;
    }

    final days = _endDate!.difference(_startDate!).inDays + 1;
    final basePrice = int.parse(widget.price.replaceAll(RegExp(r'[^\d]'), ''));
    final total = basePrice * days;

    return '₹$total';
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Venue')),
      body:
          _isProcessing
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing your booking...'),
                  ],
                ),
              )
              : Column(
                children: [
                  // Stepper indicator
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: List.generate(
                        _steps.length,
                        (index) => Expanded(
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color:
                                        index <= _currentStep
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _steps[index],
                                  style: TextStyle(
                                    fontWeight:
                                        index == _currentStep
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color:
                                        index == _currentStep
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Booking steps
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: _buildCurrentStepContent(),
                    ),
                  ),

                  // Navigation buttons
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              _calculateTotal(),
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (_currentStep > 0)
                              Expanded(
                                flex: 1,
                                child: OutlinedButton(
                                  onPressed: _previousStep,
                                  child: const Text('Back'),
                                ),
                              ),
                            if (_currentStep > 0) const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: _nextStep,
                                child: Text(
                                  _currentStep == _steps.length - 1
                                      ? 'Confirm Booking'
                                      : 'Continue',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDateSelectionStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildPaymentStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDateSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Listing summary
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.listingImage,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.listingTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${widget.price} per day'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text('Select Dates', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          InkWell(
            onTap: _selectDateRange,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _startDate != null && _endDate != null
                          ? '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}'
                          : 'Select dates',
                      style:
                          _startDate == null
                              ? TextStyle(color: Colors.grey.shade600)
                              : null,
                    ),
                  ),
                  if (_startDate != null && _endDate != null)
                    Text(
                      '${_endDate!.difference(_startDate!).inDays + 1} days',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (_startDate != null && _endDate != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Availability for selected dates:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  const Text('Available for booking'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Event Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          // Contact Person
          TextFormField(
            controller: _guestNameController,
            decoration: const InputDecoration(
              labelText: 'Contact Person Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Number
          TextFormField(
            controller: _guestPhoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Event Type
          DropdownButtonFormField<String>(
            value: _eventType,
            decoration: const InputDecoration(
              labelText: 'Event Type',
              border: OutlineInputBorder(),
            ),
            items:
                _eventTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                _eventType = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select an event type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Guest Count
          TextFormField(
            controller: _guestCountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of Guests',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the number of guests';
              }
              try {
                int guests = int.parse(value);
                if (guests < 1) {
                  return 'Please enter a valid number of guests';
                }
              } catch (e) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Special Requests
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Special Requests (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          _buildPaymentMethodTile(
            title: 'Credit/Debit Card',
            subtitle: 'Pay securely with your card',
            icon: Icons.credit_card,
            value: 'card',
          ),

          _buildPaymentMethodTile(
            title: 'UPI',
            subtitle: 'Pay using UPI apps like Google Pay, PhonePe, Paytm',
            icon: Icons.account_balance,
            value: 'upi',
          ),

          _buildPaymentMethodTile(
            title: 'Net Banking',
            subtitle: 'Pay directly from your bank account',
            icon: Icons.account_balance_wallet,
            value: 'netbanking',
          ),

          const SizedBox(height: 24),

          Text(
            'Booking Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Venue'),
                    Text(
                      widget.listingTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dates'),
                    Text(
                      _startDate != null && _endDate != null
                          ? '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}'
                          : 'Not selected',
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Price per day'), Text(widget.price)],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Duration'),
                    Text(
                      _startDate != null && _endDate != null
                          ? '${_endDate!.difference(_startDate!).inDays + 1} days'
                          : '0 days',
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _calculateTotal(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          CheckboxListTile(
            title: const Text('I agree to the terms and conditions'),
            value: true,
            onChanged: (value) {},
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    return RadioListTile<String>(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      secondary: Icon(icon),
      value: value,
      groupValue: _paymentMethod,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _paymentMethod = newValue;
          });
        }
      },
    );
  }
}
