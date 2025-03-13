import 'package:flutter/material.dart';
import 'package:vivah_dera/screens/renter/chat_screen.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _booking = {};

  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }

  void _loadBookingDetails() {
    // Simulate loading booking details
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      setState(() {
        // Mock data for the booking
        _booking = {
          'id': widget.bookingId,
          'venueName': 'Royal Wedding Hall',
          'venueImage':
              'https://source.unsplash.com/random/800x600?wedding,venue&sig=1',
          'location': 'Sector 28, Delhi',
          'startDate': DateTime.now().add(const Duration(days: 15)),
          'endDate': DateTime.now().add(const Duration(days: 16)),
          'status': 'upcoming', // upcoming, completed, canceled
          'totalAmount': '₹85,000',
          'advanceAmount': '₹20,000',
          'remainingAmount': '₹65,000',
          'guestCount': 250,
          'eventType': 'Wedding',
          'specialRequests':
              'Need stage decoration and extra lighting for the venue.',
          'createdAt': DateTime.now().subtract(const Duration(days: 5)),
          'paymentMethod': 'UPI',
          'transactionId': 'TXN123456789',
          'owner': {
            'name': 'Aman Singh',
            'image':
                'https://source.unsplash.com/random/100x100?portrait&sig=1',
            'phone': '+91 98765 43210',
            'responseRate': '95%',
            'verified': true,
          },
        };

        _isLoading = false;
      });
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
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

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Booking'),
            content: const Text(
              'Are you sure you want to cancel this booking? Cancellation fees may apply based on venue policy.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No, Keep It'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Show cancellation in progress
                  _processCancellation();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: const Text('Yes, Cancel'),
              ),
            ],
          ),
    );
  }

  void _processCancellation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing your cancellation...'),
              ],
            ),
          ),
    );

    // Simulate API call for cancellation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close progress dialog

      setState(() {
        _booking['status'] = 'canceled';
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your booking has been cancelled successfully'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _shareBookingDetails() {
    // Share booking details functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing functionality coming soon')),
    );
  }

  void _downloadTicket() {
    // In a real app, this would generate a PDF and download it
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating booking voucher...')),
    );
  }

  void _contactHost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChatScreen(
              conversationId: 'conv-${_booking['owner']['name']}',
              owner: _booking['owner'],
              propertyName: _booking['venueName'],
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking ${widget.bookingId}'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareBookingDetails,
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner image with status overlay
                    Stack(
                      children: [
                        Image.network(
                          _booking['venueImage'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            color: Colors.black.withOpacity(0.6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      _booking['status'],
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _booking['status'].toUpperCase(),
                                    style: TextStyle(
                                      color: _getStatusColor(
                                        _booking['status'],
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Booking details
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Venue name and location
                          Text(
                            _booking['venueName'],
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 4),
                              Text(_booking['location']),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Booking ID section
                          _buildSectionTitle('Booking Information'),
                          _buildDetailItem(
                            icon: Icons.confirmation_number,
                            title: 'Booking ID',
                            value: _booking['id'],
                          ),
                          _buildDetailItem(
                            icon: Icons.calendar_today,
                            title: 'Event Date',
                            value:
                                _booking['startDate'] == _booking['endDate']
                                    ? _formatDate(_booking['startDate'])
                                    : '${_formatDate(_booking['startDate'])} - ${_formatDate(_booking['endDate'])}',
                          ),
                          _buildDetailItem(
                            icon: Icons.event,
                            title: 'Event Type',
                            value: _booking['eventType'],
                          ),
                          _buildDetailItem(
                            icon: Icons.people,
                            title: 'Guest Count',
                            value: '${_booking['guestCount']} guests',
                          ),
                          _buildDetailItem(
                            icon: Icons.access_time,
                            title: 'Booked On',
                            value: _formatDate(_booking['createdAt']),
                          ),
                          const SizedBox(height: 24),

                          // Payment info
                          _buildSectionTitle('Payment Information'),
                          _buildDetailItem(
                            icon: Icons.payment,
                            title: 'Total Amount',
                            value: _booking['totalAmount'],
                            valueColor: Theme.of(context).colorScheme.primary,
                            valueBold: true,
                          ),
                          _buildDetailItem(
                            icon: Icons.check_circle,
                            title: 'Advance Paid',
                            value: _booking['advanceAmount'],
                            valueColor: Colors.green,
                          ),
                          if (_booking['status'] == 'upcoming')
                            _buildDetailItem(
                              icon: Icons.pending,
                              title: 'Balance Due',
                              value: _booking['remainingAmount'],
                              valueColor: Colors.orange,
                            ),
                          _buildDetailItem(
                            icon: Icons.credit_card,
                            title: 'Payment Method',
                            value: _booking['paymentMethod'],
                          ),
                          _buildDetailItem(
                            icon: Icons.receipt_long,
                            title: 'Transaction ID',
                            value: _booking['transactionId'],
                          ),
                          const SizedBox(height: 24),

                          // Special requests
                          _buildSectionTitle('Special Requests'),
                          Container(
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(_booking['specialRequests']),
                          ),
                          const SizedBox(height: 24),

                          // Host information
                          _buildSectionTitle('Host Information'),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                _booking['owner']['image'],
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(_booking['owner']['name']),
                                if (_booking['owner']['verified'])
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Icon(
                                      Icons.verified,
                                      size: 16,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Response Rate: ${_booking['owner']['responseRate']}',
                                ),
                                Text('Phone: ${_booking['owner']['phone']}'),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: _contactHost,
                              child: const Text('Contact'),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Action buttons based on status
                          if (_booking['status'] == 'upcoming') ...[
                            ElevatedButton.icon(
                              onPressed: _downloadTicket,
                              icon: const Icon(Icons.download),
                              label: const Text('Download Booking Voucher'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                minimumSize: const Size(double.infinity, 45),
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: _showCancelDialog,
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              label: const Text('Cancel Booking'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                minimumSize: const Size(double.infinity, 45),
                              ),
                            ),
                          ] else if (_booking['status'] == 'completed') ...[
                            ElevatedButton.icon(
                              onPressed: _downloadTicket,
                              icon: const Icon(Icons.download),
                              label: const Text('Download Receipt'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                minimumSize: const Size(double.infinity, 45),
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Review feature coming soon'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.star),
                              label: const Text('Write a Review'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 45),
                              ),
                            ),
                          ] else if (_booking['status'] == 'canceled') ...[
                            OutlinedButton.icon(
                              onPressed: () {
                                // Navigate to similar venues
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Similar venues feature coming soon',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.search),
                              label: const Text('Find Similar Venues'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 45),
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Cancellation policy
                          if (_booking['status'] == 'upcoming')
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Cancellation Policy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Free cancellation up to 30 days before event\n'
                                    '• 50% refund between 29-15 days before event\n'
                                    '• No refund within 14 days of event',
                                    style: TextStyle(
                                      color: Colors.orange.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title, style: TextStyle(color: Colors.grey.shade600)),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
