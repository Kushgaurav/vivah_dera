import 'package:flutter/material.dart';
import 'package:vivah_dera/screens/renter/booking_detail_screen.dart';
import 'package:vivah_dera/screens/renter/renter_home_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;
  final String listingTitle;
  final String listingImage;
  final DateTime startDate;
  final DateTime endDate;
  final String totalAmount;
  final int guestCount;

  const BookingConfirmationScreen({
    super.key,
    required this.bookingId,
    required this.listingTitle,
    required this.listingImage,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.guestCount,
  });

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Success icon and message
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 60,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Booking Confirmed!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your venue has been booked successfully',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Booking information card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Venue image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          listingImage,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Booking details
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listingTitle,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),

                            _buildDetailItem(
                              context,
                              'Booking ID',
                              bookingId,
                              Icons.confirmation_number,
                            ),
                            const SizedBox(height: 8),
                            _buildDetailItem(
                              context,
                              'Date',
                              startDate == endDate
                                  ? _formatDate(startDate)
                                  : '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                              Icons.calendar_today,
                            ),
                            const SizedBox(height: 8),
                            _buildDetailItem(
                              context,
                              'Guests',
                              '$guestCount guests',
                              Icons.people,
                            ),
                            const SizedBox(height: 8),
                            _buildDetailItem(
                              context,
                              'Total Amount',
                              totalAmount,
                              Icons.payment,
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      const Divider(height: 1),

                      // Download receipt button
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextButton.icon(
                          onPressed: () {
                            // In a real app, generate PDF receipt and download
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Downloading receipt...'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Download Receipt'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Next steps
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'What\'s Next?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• We\'ve sent booking details to your email\n'
                        '• The venue owner will contact you soon\n'
                        '• You can view all your bookings in the Bookings tab\n'
                        '• You can contact the venue owner through messages',
                        style: TextStyle(color: Colors.blue.shade800),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to home screen
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const RenterHomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Return to Home'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to booking details
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      BookingDetailScreen(bookingId: bookingId),
                            ),
                          );
                        },
                        child: const Text('View Booking'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Share button
                TextButton.icon(
                  onPressed: () {
                    // Share booking details
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sharing booking details...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share Booking Details'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
