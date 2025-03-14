import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _bookingData = {};

  @override
  void initState() {
    super.initState();
    _loadBookingData();
  }

  void _loadBookingData() {
    // Simulate fetching booking data from an API
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        // Mock data for the booking
        _bookingData = {
          'id': widget.bookingId,
          'venue': {
            'name': 'Royal Wedding Hall',
            'image': 'https://source.unsplash.com/random/300x200?wedding,venue',
            'location': 'Sector 18, Chandigarh',
            'phone': '+91 9876543210',
          },
          'status': _getStatusFromId(widget.bookingId),
          'booking_date': DateTime.now().subtract(const Duration(days: 5)),
          'event_date': DateTime.now().add(const Duration(days: 15)),
          'event_type': 'Wedding Ceremony',
          'guest_count': 200,
          'price_details': {
            'base_price': 45000,
            'additional_services': 25000,
            'discount': 5000,
            'taxes': 13000,
            'total': 78000,
          },
          'time_slot': 'Full Day',
          'additional_services': [
            {'name': 'Catering', 'price': 15000},
            {'name': 'Decoration', 'price': 10000},
          ],
          'special_requests':
              'Please arrange for a wedding cake display table near the entrance.',
          'payment_status': 'Paid',
          'payment_method': 'Online Payment',
          'payment_id': 'PAY123456789',
        };
        _isLoading = false;
      });
    });
  }

  String _getStatusFromId(String id) {
    // For demo purposes, determine status based on booking ID
    final hashCode = id.hashCode;
    if (hashCode % 3 == 0) return 'upcoming';
    if (hashCode % 3 == 1) return 'completed';
    return 'canceled';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking ${widget.bookingId}')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildBookingDetails(),
    );
  }

  Widget _buildBookingDetails() {
    final status = _bookingData['status'];
    final statusColor = _getStatusColor(status);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25), // equivalent to opacity 0.1
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: statusColor.withAlpha(76),
              ), // equivalent to opacity 0.3
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_getStatusIcon(status), color: statusColor),
                    const SizedBox(width: 8),
                    Text(
                      _formatStatus(status),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (status == 'upcoming')
                  Text(
                    'Your booking is confirmed for ${_formatDate(_bookingData['event_date'])}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: statusColor),
                  )
                else if (status == 'completed')
                  const Text(
                    'Thank you for using our services!',
                    textAlign: TextAlign.center,
                  )
                else
                  const Text(
                    'This booking has been canceled.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Booking ID
          _buildSectionHeader('Booking Information'),
          _buildInfoCard([
            _buildDetailRow('Booking ID', widget.bookingId, copyable: true),
            _buildDetailRow(
              'Booked On',
              _formatDate(_bookingData['booking_date']),
            ),
            _buildDetailRow(
              'Event Date',
              _formatDate(_bookingData['event_date']),
            ),
            _buildDetailRow('Event Type', _bookingData['event_type']),
            _buildDetailRow('Time Slot', _bookingData['time_slot']),
            _buildDetailRow(
              'Guest Count',
              '${_bookingData['guest_count']} people',
            ),
          ]),
          const SizedBox(height: 24),

          // Venue Details
          _buildSectionHeader('Venue Details'),
          _buildVenueCard(),
          const SizedBox(height: 24),

          // Price Details
          _buildSectionHeader('Price Details'),
          _buildPriceDetailsCard(),
          const SizedBox(height: 24),

          // Payment Information
          _buildSectionHeader('Payment Information'),
          _buildInfoCard([
            _buildDetailRow('Payment Status', _bookingData['payment_status']),
            _buildDetailRow('Payment Method', _bookingData['payment_method']),
            _buildDetailRow('Payment ID', _bookingData['payment_id']),
          ]),
          const SizedBox(height: 24),

          // Special Requests
          _buildSectionHeader('Special Requests'),
          _buildInfoCard([
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _bookingData['special_requests'] ?? 'No special requests',
              ),
            ),
          ]),
          const SizedBox(height: 32),

          // Action Buttons
          if (status == 'upcoming') _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildVenueCard() {
    final venueData = _bookingData['venue'] as Map<String, dynamic>;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Venue Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              venueData['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Venue Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venueData['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  venueData['location'],
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(venueData['phone']),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetailsCard() {
    final priceDetails = _bookingData['price_details'] as Map<String, dynamic>;
    final additionalServices =
        _bookingData['additional_services'] as List<dynamic>;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildDetailRow('Base Price', '₹${priceDetails['base_price']}'),
          if (additionalServices.isNotEmpty) const SizedBox(height: 8),
          if (additionalServices.isNotEmpty)
            ...additionalServices.map(
              (service) =>
                  _buildDetailRow(service['name'], '₹${service['price']}'),
            ),
          if (priceDetails['discount'] > 0) ...[
            const SizedBox(height: 8),
            _buildDetailRow(
              'Discount',
              '-₹${priceDetails['discount']}',
              valueColor: Colors.green,
            ),
          ],
          const SizedBox(height: 8),
          _buildDetailRow('Taxes & Fees', '₹${priceDetails['taxes']}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          _buildDetailRow(
            'Total Amount',
            '₹${priceDetails['total']}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    bool copyable = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor,
                ),
              ),
              if (copyable)
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to chat with venue owner
            Navigator.pushNamed(
              context,
              '/chat',
              arguments: {
                'conversationId': 'booking_${widget.bookingId}',
                'owner': {
                  'name': 'Aman Singh',
                  'image': 'https://source.unsplash.com/random/100x100?person',
                },
                'propertyName': _bookingData['venue']['name'],
              },
            );
          },
          icon: const Icon(Icons.message),
          label: const Text('Message Host'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 45),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            _showCancelConfirmationDialog();
          },
          icon: const Icon(Icons.cancel),
          label: const Text('Cancel Booking'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 45),
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ],
    );
  }

  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking?'),
          content: const Text(
            'Are you sure you want to cancel this booking? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No, Keep It'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _processCancellation();
              },
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _processCancellation() {
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
                Text("Processing cancellation..."),
              ],
            ),
          ),
        );
      },
    );

    // Simulate API call with delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      // Close the loading dialog
      Navigator.of(context).pop();

      // Update the UI
      setState(() {
        _bookingData['status'] = 'canceled';
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking has been canceled successfully'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'upcoming':
        return 'Upcoming';
      case 'completed':
        return 'Completed';
      case 'canceled':
        return 'Canceled';
      default:
        return 'Unknown';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'upcoming':
        return Icons.event;
      case 'completed':
        return Icons.check_circle;
      case 'canceled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
