import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _isLoading = true;
  final List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    // Simulate loading data from an API
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _conversations.addAll([
          {
            'id': 'conv1',
            'owner': {
              'name': 'Aman Singh',
              'image':
                  'https://source.unsplash.com/random/100x100?portrait,man&sig=1',
            },
            'propertyName': 'Royal Wedding Hall',
            'lastMessage': 'Yes, the venue is available on those dates.',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
            'unread': 2,
          },
          {
            'id': 'conv2',
            'owner': {
              'name': 'Priya Sharma',
              'image':
                  'https://source.unsplash.com/random/100x100?portrait,woman&sig=2',
            },
            'propertyName': 'Lakeside Farmhouse',
            'lastMessage': 'We can accommodate up to 300 guests.',
            'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
            'unread': 0,
          },
          {
            'id': 'conv3',
            'owner': {
              'name': 'Rajesh Patel',
              'image':
                  'https://source.unsplash.com/random/100x100?portrait,man&sig=3',
            },
            'propertyName': 'Conference Center',
            'lastMessage':
                'Thank you for your booking. Looking forward to hosting your event!',
            'timestamp': DateTime.now().subtract(const Duration(days: 1)),
            'unread': 0,
          },
          {
            'id': 'conv4',
            'owner': {
              'name': 'Neha Gupta',
              'image':
                  'https://source.unsplash.com/random/100x100?portrait,woman&sig=4',
            },
            'propertyName': 'Garden Party Venue',
            'lastMessage':
                'Would you like us to arrange catering services as well?',
            'timestamp': DateTime.now().subtract(const Duration(days: 3)),
            'unread': 1,
          },
        ]);
        _isLoading = false;
      });
    });
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
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search conversations
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _conversations.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                itemCount: _conversations.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final conversation = _conversations[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        conversation['owner']['image'],
                      ),
                    ),
                    title: Text(
                      conversation['owner']['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversation['propertyName'],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          conversation['lastMessage'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTimestamp(conversation['timestamp']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (conversation['unread'] > 0)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${conversation['unread']}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatScreen(
                                conversationId: conversation['id'],
                                owner: conversation['owner'],
                                propertyName: conversation['propertyName'],
                              ),
                        ),
                      );
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
          Icon(Icons.message, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Messages Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start conversations with property owners\nby inquiring about venues',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String conversationId;
  final Map<String, dynamic> owner;
  final String propertyName;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.owner,
    required this.propertyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(owner['image'])),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(owner['name'], style: const TextStyle(fontSize: 16)),
                Text(
                  propertyName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Phone call functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Conversation $conversationId will be displayed here'),
      ),
    );
  }
}
