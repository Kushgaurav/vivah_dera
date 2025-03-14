import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingConfirmationScreen({super.key, required this.bookingData});

  void _shareBooking(BuildContext context) async {
    final venue = bookingData['venue'] as Map<String, dynamic>;
    final bookingId = bookingData['booking_id'];

    final shareText =
        'I have booked ${venue['name']} on ${DateFormat('dd MMM yyyy').format(bookingData['start_date'])}!\nBooking ID: $bookingId';

    await Share.share(shareText);
  }

  Future<void> _downloadReceipt(BuildContext context) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Header(level: 0, child: pw.Text('Booking Confirmation')),
                pw.SizedBox(height: 20),
                pw.Text('Booking ID: ${bookingData['booking_id']}'),
                // Add more booking details to the PDF
              ],
            );
          }));

      final output = await getTemporaryDirectory();
      final file =
          File('${output.path}/booking_${bookingData['booking_id']}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt downloaded successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download receipt. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _callSupport() async {
    final Uri phoneUri = Uri.parse('tel:+911234567890');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch phone call';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Booking Confirmed'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareBooking(context),
              ),
            ],
          ),
          SliverFillRemaining(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final venue = bookingData['venue'] as Map<String, dynamic>;
    final bookingId = bookingData['booking_id'];
    final startDate = bookingData['start_date'] as DateTime?;
    final endDate = bookingData['end_date'] as DateTime?;
    final dateFormat = DateFormat('dd MMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Success Icon
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green.shade50,
            child: Icon(
              Icons.check_circle,
              size: 60,
              color: Colors.green.shade400,
            ),
          ),
          const SizedBox(height: 24),

          // Confirmation Text
          const Text(
            'Booking Confirmed!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Your booking has been confirmed. You will receive a confirmation email shortly.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),

          // Booking Details Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Venue Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          venue['image'] ?? '',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              venue['name'] ?? 'Venue Name',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    venue['location'] ?? 'Venue Location',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
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
                  const Divider(height: 32),

                  // Booking ID
                  _buildInfoRow('Booking ID', bookingId ?? 'N/A'),

                  // Booking Date Range
                  if (startDate != null && endDate != null)
                    _buildInfoRow(
                      'Booking Dates',
                      '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                    ),

                  // Guest Count
                  _buildInfoRow(
                    'Number of Guests',
                    '${bookingData['guest_count'] ?? 'N/A'}',
                  ),

                  // Event Name
                  _buildInfoRow(
                    'Event',
                    '${bookingData['event_name'] ?? 'N/A'} (${bookingData['event_type'] ?? 'N/A'})',
                  ),

                  // Selected Services
                  if (bookingData['services'] != null)
                    _buildInfoRow(
                      'Services',
                      (bookingData['services'] as List).join(', '),
                    ),

                  const Divider(height: 32),

                  // Payment Details
                  _buildInfoRow(
                    'Amount Paid',
                    '₹${bookingData['total_amount'] ?? 'N/A'}',
                    isBold: true,
                  ),
                  _buildInfoRow(
                    'Payment Method',
                    _formatPaymentMethod(
                      bookingData['payment_method'] ?? 'N/A',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _downloadReceipt(context),
                  icon: const Icon(Icons.download),
                  label: const Text('Download Receipt'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/renter_home');
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Go to Home'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Support Contact
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.support_agent, color: Colors.blue.shade700),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need Help?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Contact our support team for any questions.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await _callSupport();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Could not initiate call. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Call'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'online':
        return 'Online Payment';
      case 'bank':
        return 'Bank Transfer';
      default:
        return method;
    }
  }
}
