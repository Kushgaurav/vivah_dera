import 'package:flutter/material.dart';

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  final List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadBookings() {
    // Simulate loading data from an API
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _bookings.addAll([
          {
            'id': 'BK1001',
            'venueName': 'Royal Wedding Hall',
            'image':
                'https://source.unsplash.com/random/300x200?wedding,venue&sig=1',
            'customerName': 'Rahul Sharma',
            'customerPhone': '+91 98765 43210',
            'startDate': DateTime.now().add(const Duration(days: 5)),
            'endDate': DateTime.now().add(const Duration(days: 6)),
            'status': 'pending',
            'amount': '₹45,000',
            'eventType': 'Wedding',
            'guestCount': 250,
            'createdAt': DateTime.now().subtract(const Duration(hours: 6)),
            'notes': 'Need stage decoration and seating for 250 people',
          },
          {
            'id': 'BK1002',
            'venueName': 'Royal Wedding Hall',
            'image':
                'https://source.unsplash.com/random/300x200?wedding,venue&sig=2',
            'customerName': 'Priya Patel',
            'customerPhone': '+91 97654 32109',
            'startDate': DateTime.now().add(const Duration(days: 10)),
            'endDate': DateTime.now().add(const Duration(days: 10)),
            'status': 'pending',
            'amount': '₹35,000',
            'eventType': 'Birthday Party',
            'guestCount': 100,
            'createdAt': DateTime.now().subtract(const Duration(days: 1)),
            'notes': 'Birthday celebration for 50th anniversary',
          },
          {
            'id': 'BK1003',
            'venueName': 'Conference Hall',
            'image':
                'https://source.unsplash.com/random/300x200?conference&sig=3',
            'customerName': 'Vikram Singh',
            'customerPhone': '+91 87654 32109',
            'startDate': DateTime.now().add(const Duration(days: 15)),
            'endDate': DateTime.now().add(const Duration(days: 15)),
            'status': 'confirmed',
            'amount': '₹25,000',
            'eventType': 'Conference',
            'guestCount': 80,
            'createdAt': DateTime.now().subtract(const Duration(days: 3)),
            'notes': 'Annual company meeting with projector setup',
          },
          {
            'id': 'BK1004',
            'venueName': 'Garden Party Venue',
            'image':
                'https://source.unsplash.com/random/300x200?garden,party&sig=4',
            'customerName': 'Neha Gupta',
            'customerPhone': '+91 76543 21098',
            'startDate': DateTime.now().add(const Duration(days: 20)),
            'endDate': DateTime.now().add(const Duration(days: 21)),
            'status': 'confirmed',
            'amount': '₹60,000',
            'eventType': 'Wedding',
            'guestCount': 300,
            'createdAt': DateTime.now().subtract(const Duration(days: 5)),
            'notes': 'Need outdoor seating with tenting arrangement',
          },
          {
            'id': 'BK1005',
            'venueName': 'Royal Wedding Hall',
            'image':
                'https://source.unsplash.com/random/300x200?wedding,venue&sig=5',
            'customerName': 'Amit Kumar',
            'customerPhone': '+91 65432 10987',
            'startDate': DateTime.now().subtract(const Duration(days: 10)),
            'endDate': DateTime.now().subtract(const Duration(days: 9)),
            'status': 'completed',
            'amount': '₹50,000',
            'eventType': 'Wedding Reception',
            'guestCount': 200,
            'createdAt': DateTime.now().subtract(const Duration(days: 15)),
            'notes': 'Wedding reception with catering arrangements',
          },
          {
            'id': 'BK1006',
            'venueName': 'Conference Hall',
            'image':
                'https://source.unsplash.com/random/300x200?conference&sig=6',
            'customerName': 'Sanjay Mehta',
            'customerPhone': '+91 54321 09876',
            'startDate': DateTime.now().subtract(const Duration(days: 20)),
            'endDate': DateTime.now().subtract(const Duration(days: 20)),
            'status': 'completed',
            'amount': '₹30,000',
            'eventType': 'Product Launch',
            'guestCount': 120,
            'createdAt': DateTime.now().subtract(const Duration(days: 25)),
            'notes': 'Product launch event with media coverage',
          },
        ]);

        _isLoading = false;
      });
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String _getTimeAgo(DateTime date) {
    final Duration difference = DateTime.now().difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _handleBookingAction(Map<String, dynamic> booking, String action) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              action == 'accept' ? 'Accept Booking' : 'Decline Booking',
            ),
            content: Text(
              action == 'accept'
                  ? 'Are you sure you want to accept this booking request?'
                  : 'Are you sure you want to decline this booking request?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      action == 'accept' ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _processBookingAction(booking, action);
                },
                child: Text(action == 'accept' ? 'Accept' : 'Decline'),
              ),
            ],
          ),
    );
  }

  void _processBookingAction(Map<String, dynamic> booking, String action) {
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        // Update the booking status
        for (var i = 0; i < _bookings.length; i++) {
          if (_bookings[i]['id'] == booking['id']) {
            _bookings[i]['status'] =
                action == 'accept' ? 'confirmed' : 'declined';
            break;
          }
        }
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            action == 'accept'
                ? 'Booking has been accepted successfully!'
                : 'Booking has been declined.',
          ),
          backgroundColor: action == 'accept' ? Colors.green : Colors.red,
        ),
      );
    });
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          booking['image'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Booking ID and status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Booking ID: ${booking['id']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _buildStatusBadge(booking['status']),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildDetailItem(
                        title: 'Venue',
                        value: booking['venueName'],
                      ),
                      _buildDetailItem(
                        title: 'Customer Name',
                        value: booking['customerName'],
                      ),
                      _buildDetailItem(
                        title: 'Contact Number',
                        value: booking['customerPhone'],
                        icon: Icons.phone,
                        isPhone: true,
                      ),
                      _buildDetailItem(
                        title: 'Event Date',
                        value:
                            booking['startDate'] == booking['endDate']
                                ? _formatDate(booking['startDate'])
                                : '${_formatDate(booking['startDate'])} - ${_formatDate(booking['endDate'])}',
                        icon: Icons.calendar_today,
                      ),
                      _buildDetailItem(
                        title: 'Event Type',
                        value: booking['eventType'],
                      ),
                      _buildDetailItem(
                        title: 'Guest Count',
                        value: '${booking['guestCount']} guests',
                        icon: Icons.people,
                      ),
                      _buildDetailItem(
                        title: 'Booking Amount',
                        value: booking['amount'],
                        icon: Icons.payments,
                      ),
                      _buildDetailItem(
                        title: 'Booking Created',
                        value: _getTimeAgo(booking['createdAt']),
                        icon: Icons.access_time,
                      ),

                      const SizedBox(height: 8),
                      const Text(
                        'Special Requests',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(booking['notes']),
                      ),

                      const SizedBox(height: 24),

                      // Action buttons for pending bookings
                      if (booking['status'] == 'pending')
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _handleBookingAction(booking, 'accept');
                                },
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Accept'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _handleBookingAction(booking, 'decline');
                                },
                                icon: const Icon(Icons.cancel),
                                label: const Text('Decline'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                      // Contact button for confirmed bookings
                      if (booking['status'] == 'confirmed')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Implement call functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calling customer...'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.call),
                            label: const Text('Contact Customer'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String value,
    IconData? icon,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          Expanded(
            child:
                isPhone
                    ? TextButton(
                      onPressed: () {
                        // Implement calling functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Calling $value')),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    )
                    : Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case 'pending':
        backgroundColor = Colors.amber.shade100;
        textColor = Colors.amber.shade900;
        text = 'Pending';
        break;
      case 'confirmed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = 'Confirmed';
        break;
      case 'completed':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        text = 'Completed';
        break;
      case 'declined':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        text = 'Declined';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        text = status.substring(0, 1).toUpperCase() + status.substring(1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  // Pending tab
                  _buildBookingList('pending'),

                  // Confirmed tab
                  _buildBookingList('confirmed'),

                  // Past tab (Completed)
                  _buildBookingList('completed'),
                ],
              ),
    );
  }

  Widget _buildBookingList(String status) {
    final filteredBookings =
        _bookings.where((booking) => booking['status'] == status).toList();

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'pending'
                  ? Icons.pending_actions
                  : status == 'confirmed'
                  ? Icons.event_available
                  : Icons.history,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No $status bookings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              status == 'pending'
                  ? 'You don\'t have any pending booking requests'
                  : status == 'confirmed'
                  ? 'No upcoming confirmed bookings'
                  : 'No past bookings to display',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showBookingDetails(booking),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          booking['customerName'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        booking['amount'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking['startDate'] == booking['endDate']
                                ? _formatDate(booking['startDate'])
                                : '${_formatDate(booking['startDate'])} - ${_formatDate(booking['endDate'])}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.people,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${booking['guestCount']} guests',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            booking['eventType'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _getTimeAgo(booking['createdAt']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (status == 'pending')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                () => _handleBookingAction(booking, 'decline'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text('Decline'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                () => _handleBookingAction(booking, 'accept'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (status == 'confirmed')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Implement messaging functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Messaging functionality coming soon',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.message),
                            label: const Text('Message'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Implement call functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Calling ${booking['customerName']}...',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.call),
                            label: const Text('Call'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
