import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
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

  void _loadBookings() {
    // Simulate loading data from an API
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _bookings.addAll([
          {
            'id': 'B123456',
            'venueName': 'Royal Wedding Hall',
            'image':
                'https://source.unsplash.com/random/300x200?wedding,venue&sig=1',
            'startDate': DateTime.now().add(const Duration(days: 15)),
            'endDate': DateTime.now().add(const Duration(days: 16)),
            'status': 'upcoming',
            'totalAmount': '₹85,000',
            'guestCount': 250,
          },
          {
            'id': 'B123457',
            'venueName': 'Lakeside Farmhouse',
            'image':
                'https://source.unsplash.com/random/300x200?farmhouse&sig=2',
            'startDate': DateTime.now().add(const Duration(days: 45)),
            'endDate': DateTime.now().add(const Duration(days: 46)),
            'status': 'upcoming',
            'totalAmount': '₹120,000',
            'guestCount': 300,
          },
          {
            'id': 'B123458',
            'venueName': 'Conference Center',
            'image':
                'https://source.unsplash.com/random/300x200?conference&sig=3',
            'startDate': DateTime.now().subtract(const Duration(days: 30)),
            'endDate': DateTime.now().subtract(const Duration(days: 29)),
            'status': 'completed',
            'totalAmount': '₹45,000',
            'guestCount': 50,
          },
          {
            'id': 'B123459',
            'venueName': 'Garden Party Venue',
            'image':
                'https://source.unsplash.com/random/300x200?garden,party&sig=4',
            'startDate': DateTime.now().subtract(const Duration(days: 60)),
            'endDate': DateTime.now().subtract(const Duration(days: 59)),
            'status': 'completed',
            'totalAmount': '₹35,000',
            'guestCount': 100,
          },
          {
            'id': 'B123460',
            'venueName': 'Luxury Tent House',
            'image': 'https://source.unsplash.com/random/300x200?tent&sig=5',
            'startDate': DateTime.now().subtract(const Duration(days: 5)),
            'endDate': DateTime.now().subtract(const Duration(days: 3)),
            'status': 'canceled',
            'totalAmount': '₹75,000',
            'guestCount': 200,
          },
        ]);
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Canceled'),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  // Upcoming tab
                  _buildBookingList('upcoming'),

                  // Completed tab
                  _buildBookingList('completed'),

                  // Canceled tab
                  _buildBookingList('canceled'),
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
              status == 'upcoming'
                  ? Icons.event_available
                  : status == 'completed'
                  ? Icons.check_circle
                  : Icons.cancel,
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
              status == 'upcoming'
                  ? 'Your upcoming bookings will appear here'
                  : status == 'completed'
                  ? 'Your completed bookings will appear here'
                  : 'Your canceled bookings will appear here',
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
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          BookingDetailScreen(bookingId: booking['id']),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and booking ID
                Stack(
                  children: [
                    Image.network(
                      booking['image'],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(
                            179,
                          ), // equivalent to opacity 0.7
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Booking ID: ${booking['id']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Venue name
                      Text(
                        booking['venueName'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Date range
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            '${_formatDate(booking['startDate'])} - ${_formatDate(booking['endDate'])}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Guest count
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            '${booking['guestCount']} guests',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Total and status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            booking['totalAmount'],
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  status == 'upcoming'
                                      ? Colors.blue.shade100
                                      : status == 'completed'
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status.capitalize(),
                              style: TextStyle(
                                color:
                                    status == 'upcoming'
                                        ? Colors.blue.shade700
                                        : status == 'completed'
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                fontWeight: FontWeight.bold,
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
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class BookingDetailScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking $bookingId')),
      body: Center(
        child: Text('Booking details for $bookingId will be shown here'),
      ),
    );
  }
}
