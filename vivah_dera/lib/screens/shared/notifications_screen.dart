import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  final List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    // Simulate loading notifications
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _notifications.addAll([
          {
            'id': '1',
            'title': 'Booking Confirmed',
            'body': 'Your booking for Royal Wedding Hall has been confirmed',
            'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
            'isRead': false,
            'type': 'booking',
          },
          {
            'id': '2',
            'title': 'New Message',
            'body': 'You have a new message from Aman Singh',
            'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
            'isRead': true,
            'type': 'message',
          },
          {
            'id': '3',
            'title': 'Payment Successful',
            'body': 'Payment of ₹25,000 has been processed successfully',
            'timestamp': DateTime.now().subtract(const Duration(days: 1)),
            'isRead': true,
            'type': 'payment',
          },
        ]);
        _isLoading = false;
      });
    });
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_today;
      case 'message':
        return Icons.message;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'booking':
        return Colors.green;
      case 'message':
        return Colors.blue;
      case 'payment':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var notification in _notifications) {
                    notification['isRead'] = true;
                  }
                });
              },
              child: const Text('Mark all as read'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromRGBO(
                          _getNotificationColor(notification['type']).r.toInt(),
                          _getNotificationColor(notification['type']).g.toInt(),
                          _getNotificationColor(notification['type']).b.toInt(),
                          0.2,
                        ),
                        child: Icon(
                          _getNotificationIcon(notification['type']),
                          color: _getNotificationColor(notification['type']),
                        ),
                      ),
                      title: Text(
                        notification['title'],
                        style: TextStyle(
                          fontWeight: notification['isRead']
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification['body']),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimestamp(notification['timestamp']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          notification['isRead'] = true;
                        });
                        // Handle notification tap based on type
                        switch (notification['type']) {
                          case 'booking':
                            Navigator.pushNamed(context, '/booking_detail');
                            break;
                          case 'message':
                            Navigator.pushNamed(context, '/chat');
                            break;
                          case 'payment':
                            // Handle payment notification
                            break;
                        }
                      },
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 70,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}
