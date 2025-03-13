import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChatScreen extends StatefulWidget {
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
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isTyping = false;
  List<Message> _messages = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // In a real app, we'd load messages from a database or API
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        // Generate some mock messages
        final now = DateTime.now();
        _messages = [
          Message(
            text: 'Hi, I\'m interested in booking your venue for a wedding.',
            timestamp: now.subtract(const Duration(days: 3, hours: 2)),
            isMe: true,
          ),
          Message(
            text:
                'Hello! Thank you for your interest. When are you planning to have your wedding?',
            timestamp: now.subtract(
              const Duration(days: 3, hours: 1, minutes: 45),
            ),
            isMe: false,
          ),
          Message(
            text: 'We\'re looking at dates in next month, around the 15th.',
            timestamp: now.subtract(
              const Duration(days: 3, hours: 1, minutes: 30),
            ),
            isMe: true,
          ),
          Message(
            text: 'That should work. How many guests are you expecting?',
            timestamp: now.subtract(const Duration(days: 3, hours: 1)),
            isMe: false,
          ),
          Message(
            text: 'Around 200 people.',
            timestamp: now.subtract(const Duration(days: 3)),
            isMe: true,
          ),
          Message(
            text:
                'Great! We can accommodate up to 500 guests. Would you like to schedule a visit to see the venue?',
            timestamp: now.subtract(const Duration(days: 2, hours: 5)),
            isMe: false,
          ),
          Message(
            text: 'Yes, that would be helpful. When can we come and see it?',
            timestamp: now.subtract(const Duration(days: 2)),
            isMe: true,
          ),
          Message(
            text:
                'We have availability tomorrow afternoon or anytime this weekend. What works best for you?',
            timestamp: now.subtract(const Duration(days: 1, hours: 12)),
            isMe: false,
          ),
        ];

        _isLoading = false;
      });

      // Scroll to bottom
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = Message(
      text: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate reply
    _simulateReply();
  }

  void _simulateReply() {
    // Simulate typing indicator
    setState(() {
      _isTyping = true;
    });

    // Simulate reply after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isTyping = false;
        _messages.add(
          Message(
            text: _getRandomReply(),
            timestamp: DateTime.now(),
            isMe: false,
          ),
        );
      });

      // Scroll to bottom
      _scrollToBottom();
    });
  }

  String _getRandomReply() {
    final replies = [
      "That sounds great!",
      "Thank you for letting me know.",
      "Perfect! Is there anything else you'd like to know?",
      "I'll check our availability and get back to you.",
      "We can definitely accommodate that request.",
      "Would you like to schedule a visit to see the venue in person?",
      "Let me know if you have any other questions!",
      "I've made a note of your requirements.",
    ];

    return replies[math.Random().nextInt(replies.length)];
  }

  void _scrollToBottom() {
    // Scroll to bottom after a short delay to ensure the list has rendered
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatMessageTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      // Format as date if older than a week
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      // Format as days ago
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      // Format as hours ago
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      // Format as minutes ago
      return '${difference.inMinutes} min ago';
    } else {
      // Just now
      return 'Just now';
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Photo upload coming soon')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Camera access coming soon'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Document'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Document upload coming soon'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Location'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Location sharing coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.owner['image'])),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.owner['name'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.propertyName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Implement phone call functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Call feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder:
                    (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.block),
                            title: const Text('Block User'),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Block functionality coming soon',
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.report),
                            title: const Text('Report Issue'),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Report functionality coming soon',
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete_outline),
                            title: const Text('Clear Chat'),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Clear chat coming soon'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Property booking info banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Have questions about the venue? Ask the owner directly.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final showTimestamp =
                            index == 0 ||
                            _shouldShowTimestamp(
                              _messages[index].timestamp,
                              _messages[index - 1].timestamp,
                            );

                        return Column(
                          children: [
                            if (showTimestamp)
                              _buildTimestampDivider(message.timestamp),
                            _buildMessageBubble(message),
                          ],
                        );
                      },
                    ),
          ),

          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(width: 40, child: _TypingIndicator()),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.owner['name']} is typing...',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _showAttachmentOptions,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowTimestamp(DateTime current, DateTime previous) {
    // Show timestamp if messages are more than 15 minutes apart
    return current.difference(previous).inMinutes > 15;
  }

  Widget _buildTimestampDivider(DateTime timestamp) {
    final dateFormat = _formatDate(timestamp);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              dateFormat,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              message.isMe
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: message.isMe ? const Radius.circular(0) : null,
            bottomLeft: !message.isMe ? const Radius.circular(0) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatMessageTimestamp(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          message.isMe
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey.shade600,
                    ),
                  ),
                  if (message.isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all,
                      size: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start the conversation by sending a message',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final DateTime timestamp;
  final bool isMe;

  Message({required this.text, required this.timestamp, required this.isMe});
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(3, (index) {
            final delay = index * 0.3;
            final position = _controller.value - delay;
            final opacity =
                position < 0.0
                    ? 0.0
                    : position > 1.0
                    ? 0.0
                    : position;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                height: 6 + 3 * opacity,
                width: 6 + 3 * opacity,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.5 + opacity * 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
