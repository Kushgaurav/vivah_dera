import 'package:flutter/material.dart';
import 'package:vivah_dera/widgets/date_range_picker.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Booking form data
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 1: Date & Guest info
  DateTime? _startDate;
  DateTime? _endDate;
  final _guestCountController = TextEditingController(text: '100');
  bool _isFullDay = true;
  final List<String> _selectedTimeSlots = [];

  // Step 2: Event info
  final _eventNameController = TextEditingController();
  final _eventTypeController = TextEditingController();
  final _specialRequestsController = TextEditingController();
  final List<String> _selectedServices = [];

  // Step 3: Contact & payment info
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedPaymentMethod = 'online';

  // Venue data (would normally come from previous screen)
  final Map<String, dynamic> _venue = {
    'id': 'venue1',
    'name': 'Royal Wedding Hall',
    'image': 'https://source.unsplash.com/random/800x600?wedding+hall',
    'price': 45000,
    'location': 'Sector 18, Chandigarh',
    'rating': 4.8,
  };

  // Available services with additional prices
  final List<Map<String, dynamic>> _availableServices = [
    {'id': 'catering', 'name': 'Catering Services', 'price': 15000},
    {'id': 'decoration', 'name': 'Decoration', 'price': 10000},
    {'id': 'photography', 'name': 'Photography & Videography', 'price': 25000},
    {'id': 'dj', 'name': 'DJ & Music', 'price': 8000},
    {'id': 'transport', 'name': 'Transportation', 'price': 5000},
  ];

  // Available time slots
  final List<Map<String, dynamic>> _timeSlots = [
    {'id': 'morning', 'name': 'Morning (8 AM - 12 PM)', 'price': 15000},
    {'id': 'afternoon', 'name': 'Afternoon (12 PM - 4 PM)', 'price': 20000},
    {'id': 'evening', 'name': 'Evening (4 PM - 8 PM)', 'price': 25000},
    {'id': 'night', 'name': 'Night (8 PM - 12 AM)', 'price': 30000},
  ];

  @override
  void dispose() {
    _guestCountController.dispose();
    _eventNameController.dispose();
    _eventTypeController.dispose();
    _specialRequestsController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Calculate the total booking price
  int _calculateTotal() {
    int basePrice = _venue['price'] as int;

    // Calculate duration in days
    int durationDays = 1;
    if (_startDate != null && _endDate != null) {
      durationDays = _endDate!.difference(_startDate!).inDays + 1;
    }

    // Time slot pricing (if not full day)
    int timeSlotPrice = 0;
    if (!_isFullDay) {
      for (String slotId in _selectedTimeSlots) {
        final slot = _timeSlots.firstWhere((slot) => slot['id'] == slotId);
        timeSlotPrice += slot['price'] as int;
      }
      return timeSlotPrice * durationDays;
    }

    // Full day pricing
    int fullDayPrice = basePrice * durationDays;

    // Add additional services
    int servicesPrice = 0;
    for (String serviceId in _selectedServices) {
      final service = _availableServices.firstWhere(
        (service) => service['id'] == serviceId,
      );
      servicesPrice += service['price'] as int;
    }

    return fullDayPrice + servicesPrice;
  }

  void _nextStep() {
    if (_currentStep < 2) {
      // Validate current step before proceeding
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
      }
    } else {
      // Final validation and submission
      if (_validateCurrentStep()) {
        _submitBooking();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  bool _validateCurrentStep() {
    // Validation logic for each step
    switch (_currentStep) {
      case 0:
        if (_startDate == null || _endDate == null) {
          _showErrorSnackbar('Please select your booking dates');
          return false;
        }
        if (!_isFullDay && _selectedTimeSlots.isEmpty) {
          _showErrorSnackbar('Please select at least one time slot');
          return false;
        }
        if (_guestCountController.text.isEmpty ||
            int.tryParse(_guestCountController.text) == null) {
          _showErrorSnackbar('Please enter a valid guest count');
          return false;
        }
        return true;

      case 1:
        if (_eventNameController.text.isEmpty) {
          _showErrorSnackbar('Please enter an event name');
          return false;
        }
        if (_eventTypeController.text.isEmpty) {
          _showErrorSnackbar('Please enter the event type');
          return false;
        }
        return true;

      case 2:
        if (_nameController.text.isEmpty) {
          _showErrorSnackbar('Please enter your name');
          return false;
        }
        if (_phoneController.text.isEmpty ||
            _phoneController.text.length < 10) {
          _showErrorSnackbar('Please enter a valid phone number');
          return false;
        }
        if (_emailController.text.isEmpty ||
            !_emailController.text.contains('@')) {
          _showErrorSnackbar('Please enter a valid email');
          return false;
        }
        return true;

      default:
        return false;
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _submitBooking() {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Processing your booking..."),
              ],
            ),
          ),
        );
      },
    );

    // Simulate API call with delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Check if the widget is still mounted
      // Close dialog and navigate to confirmation
      Navigator.of(context).pop();

      // Create booking data to pass to confirmation screen
      final bookingData = {
        'venue': _venue,
        'booking_id': 'B${DateTime.now().millisecondsSinceEpoch}',
        'start_date': _startDate,
        'end_date': _endDate,
        'time_slots': _selectedTimeSlots,
        'guest_count': int.parse(_guestCountController.text),
        'event_name': _eventNameController.text,
        'event_type': _eventTypeController.text,
        'special_requests': _specialRequestsController.text,
        'services': _selectedServices,
        'total_amount': _calculateTotal(),
        'payment_method': _selectedPaymentMethod,
      };

      // Navigate to confirmation screen
      Navigator.pushReplacementNamed(
        context,
        '/booking_confirmation',
        arguments: bookingData,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get venue data from arguments if available
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('venue')) {
      // Use venue data from arguments
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Book Venue')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Venue info card
            _buildVenueInfoCard(),

            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  _buildStepIndicator(0, 'Dates'),
                  _buildStepDivider(),
                  _buildStepIndicator(1, 'Details'),
                  _buildStepDivider(),
                  _buildStepIndicator(2, 'Checkout'),
                ],
              ),
            ),

            // Step content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _buildCurrentStepContent(),
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(
                      51,
                    ), // equivalent to opacity 0.2
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Price', style: TextStyle(fontSize: 12)),
                      Text(
                        '₹${_calculateTotal()}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),

                  // Buttons
                  Row(
                    children: [
                      if (_currentStep > 0)
                        OutlinedButton(
                          onPressed: _previousStep,
                          child: const Text('Previous'),
                        ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _nextStep,
                        child: Text(_currentStep < 2 ? 'Next' : 'Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Venue image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              _venue['image'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Venue details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _venue['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _venue['location'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Base price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Base Price'),
              Text(
                '₹${_venue['price']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String label) {
    final isActive = _currentStep >= stepIndex;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isActive ? Theme.of(context).primaryColor : Colors.grey[300],
            ),
            child: Center(
              child: Text(
                (stepIndex + 1).toString(),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  isActive ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider() {
    return Container(height: 1, width: 40, color: Colors.grey[300]);
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDateAndGuestsStep();
      case 1:
        return _buildEventDetailsStep();
      case 2:
        return _buildContactAndPaymentStep();
      default:
        return Container();
    }
  }

  Widget _buildDateAndGuestsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Dates',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Date range picker
        DateRangePicker(
          startDate: _startDate,
          endDate: _endDate,
          onStartDateChanged: (date) {
            setState(() {
              _startDate = date;
              // Ensure end date is not before start date
              if (_endDate != null && _endDate!.isBefore(date)) {
                _endDate = date;
              }
            });
          },
          onEndDateChanged: (date) {
            setState(() {
              _endDate = date;
            });
          },
          onDateRangeSelected: (startDate, endDate) {
            setState(() {
              _startDate = startDate;
              _endDate = endDate;
            });
          },
        ),

        const SizedBox(height: 24),

        // Time slot selection
        const Text(
          'Booking Type',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Full day or specific slots
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Full Day'),
                value: true,
                groupValue: _isFullDay,
                onChanged: (value) {
                  setState(() {
                    _isFullDay = value!;
                    _selectedTimeSlots.clear();
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Time Slots'),
                value: false,
                groupValue: _isFullDay,
                onChanged: (value) {
                  setState(() {
                    _isFullDay = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),

        if (!_isFullDay)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Time Slots:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _timeSlots.map((slot) {
                      final isSelected = _selectedTimeSlots.contains(
                        slot['id'],
                      );
                      return FilterChip(
                        label: Text('${slot['name']} (₹${slot['price']})'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTimeSlots.add(slot['id']);
                            } else {
                              _selectedTimeSlots.remove(slot['id']);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
            ],
          ),

        const SizedBox(height: 24),

        // Guest count
        const Text(
          'Number of Guests',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: _guestCountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter number of guests',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter number of guests';
            }
            final guestCount = int.tryParse(value);
            if (guestCount == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEventDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Event name
        TextFormField(
          controller: _eventNameController,
          decoration: const InputDecoration(
            labelText: 'Event Name',
            hintText: 'E.g., John & Sarah\'s Wedding',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter event name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Event type
        TextFormField(
          controller: _eventTypeController,
          decoration: const InputDecoration(
            labelText: 'Event Type',
            hintText: 'E.g., Wedding, Birthday, Corporate',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter event type';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Special requests
        TextFormField(
          controller: _specialRequestsController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Special Requests (Optional)',
            hintText: 'Any special arrangements or requirements?',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 24),

        // Additional services
        const Text(
          'Additional Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        ..._availableServices.map((service) {
          final isSelected = _selectedServices.contains(service['id']);
          return CheckboxListTile(
            title: Text(service['name']),
            subtitle: Text('₹${service['price']}'),
            value: isSelected,
            onChanged: (selected) {
              setState(() {
                if (selected!) {
                  _selectedServices.add(service['id']);
                } else {
                  _selectedServices.remove(service['id']);
                }
              });
            },
            contentPadding: EdgeInsets.zero,
          );
        }),
      ],
    );
  }

  Widget _buildContactAndPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Name
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Phone
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone_outlined),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),

        const SizedBox(height: 24),

        // Payment method
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        RadioListTile<String>(
          title: Row(
            children: [
              Icon(Icons.payment, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              const Text('Pay Online'),
              const Spacer(),
              Image.asset('assets/images/credit_cards.png', height: 24),
            ],
          ),
          value: 'online',
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
        ),

        RadioListTile<String>(
          title: Row(
            children: [
              Icon(
                Icons.account_balance,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 10),
              const Text('Bank Transfer'),
            ],
          ),
          value: 'bank',
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
        ),

        const SizedBox(height: 16),

        // Booking summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildSummaryRow('Venue', _venue['name']),
              if (_startDate != null && _endDate != null)
                _buildSummaryRow(
                  'Dates',
                  '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}',
                ),
              _buildSummaryRow('Guests', _guestCountController.text),
              _buildSummaryRow(
                'Booking Type',
                _isFullDay ? 'Full Day' : 'Time Slots',
              ),
              if (_selectedServices.isNotEmpty)
                _buildSummaryRow(
                  'Additional Services',
                  '${_selectedServices.length} selected',
                ),
              const Divider(),
              _buildSummaryRow(
                'Total Amount',
                '₹${_calculateTotal()}',
                isBold: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Terms and conditions
        CheckboxListTile(
          title: const Text('I agree to the Terms and Conditions'),
          value: true,
          onChanged: (value) {
            // Required checkbox, so no need to update state
          },
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
