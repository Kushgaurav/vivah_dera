import 'package:flutter/material.dart';
import 'package:vivah_dera/screens/owner/owner_bookings_screen.dart';
import 'package:vivah_dera/screens/owner/owner_calendar_screen.dart';
import 'package:vivah_dera/screens/owner/owner_listings_screen.dart';
import 'package:vivah_dera/screens/renter/messages_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardPage(),
    const OwnerListingsScreen(),
    const OwnerCalendarScreen(),
    const OwnerBookingsScreen(),
    const MessagesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listing_editor');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back, Venue Owner!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // Statistics Cards
          const Text(
            'Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildStatsGrid(context),

          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildQuickActionButtons(context),

          const SizedBox(height: 24),

          // Recent Bookings
          _buildRecentBookings(context),

          const SizedBox(height: 24),

          // To-Do List
          _buildTodoList(context),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard(context, 'Total Listings', '12', Icons.home_work),
        _buildStatCard(context, 'Total Bookings', '34', Icons.book_online),
        _buildStatCard(
          context,
          'Total Revenue',
          '₹1,20,000',
          Icons.attach_money,
        ),
        _buildStatCard(context, 'Pending Requests', '5', Icons.pending_actions),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/listing_editor');
            },
            icon: const Icon(Icons.add_home),
            label: const Text('Add Listing'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/owner_calendar');
            },
            icon: const Icon(Icons.event_available),
            label: const Text('Set Availability'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBookings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Bookings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://source.unsplash.com/random/100x100?person=$index',
                  ),
                ),
                title: Text('Booking #${index + 1}'),
                subtitle: Text(
                  'Venue: Royal Wedding Hall\nDate: 25th Dec 2023',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/booking_detail',
                      arguments: {'bookingId': 'BOOKING${index + 1}'},
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTodoList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'To-Do List',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CheckboxListTile(
                title: const Text('Complete profile information'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('Upload photos for Royal Garden Hall'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('Respond to booking request from Rahul'),
                value: true,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('Update pricing for weekend packages'),
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
