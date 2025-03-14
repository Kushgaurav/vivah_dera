import 'package:flutter/material.dart';

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
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Simulate fetching messages from an API
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      setState(() {
        // Add mock messages
        _messages.addAll([
          {
            'id': '1',
            'sender': 'owner',
            'text':
                'Hello! How can I help you regarding ${widget.propertyName}?',
            'timestamp': DateTime.now().subtract(
              const Duration(days: 2, hours: 3),
            ),
            'isRead': true,
          },
          {
            'id': '2',
            'sender': 'user',
            'text':
                'Hi! I\'m interested in booking your venue for a wedding next month.',
            'timestamp': DateTime.now().subtract(
              const Duration(days: 2, hours: 2),
            ),
            'isRead': true,
          },
          {
            'id': '3',
            'sender': 'owner',
            'text':
                'That\'s great! We have several dates available next month. Do you have specific dates in mind?',
            'timestamp': DateTime.now().subtract(
              const Duration(days: 2, hours: 2),
            ),
            'isRead': true,
          },
          {
            'id': '4',
            'sender': 'user',
            'text':
                'We\'re looking at the 15th and 16th. Would those be available?',
            'timestamp': DateTime.now().subtract(
              const Duration(days: 2, hours: 1),
            ),
            'isRead': true,
          },
          {
            'id': '5',
            'sender': 'owner',
            'text':
                'Let me check our calendar... Yes, both dates are currently available!',
            'timestamp': DateTime.now().subtract(const Duration(days: 2)),
            'isRead': true,
          },
          {
            'id': '6',
            'sender': 'owner',
            'text':
                'Would you like to come visit the venue before making a booking?',
            'timestamp': DateTime.now().subtract(
              const Duration(days: 1, hours: 12),
            ),
            'isRead': true,
          },
        ]);

        _isLoading = false;
      });

      // Scroll to bottom after messages load
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text;
    _messageController.clear();

    // Add the message locally first
    setState(() {
      _isSending = true;
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender': 'user',
        'text': messageText,
        'timestamp': DateTime.now(),
        'isRead': false,
        'isPending': true,
      });
    });

    // Scroll to bottom immediately after sending
    _scrollToBottom();

    // Simulate sending to API
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        // Update the status of the sent message
        final lastMessage = _messages.last;
        lastMessage['isPending'] = false;
        _isSending = false;
      });

      // Simulate receiving reply
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        setState(() {
          _messages.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'sender': 'owner',
            'text': _getAutoResponse(messageText),
            'timestamp': DateTime.now(),
            'isRead': true,
          });
        });

        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _getAutoResponse(String message) {
    // Simple auto-response system for demo
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('price') || lowerMessage.contains('cost')) {
      return 'Our pricing starts at ₹45,000 per day. This includes basic venue setup.';
    } else if (lowerMessage.contains('capacity') ||
        lowerMessage.contains('people')) {
      return 'Our venue can accommodate up to 500 guests comfortably.';
    } else if (lowerMessage.contains('available') ||
        lowerMessage.contains('date')) {
      return 'Yes, we do have availability. Let me know your preferred date and I can confirm for you!';
    } else if (lowerMessage.contains('food') ||
        lowerMessage.contains('catering')) {
      return 'We offer in-house catering with various menu options. We can also work with external caterers for an additional fee.';
    } else if (lowerMessage.contains('visit') ||
        lowerMessage.contains('tour')) {
      return 'You\'re welcome to visit for a tour any day between 10am-6pm. Would you like to schedule a specific time?';
    } else if (lowerMessage.contains('thank')) {
      return 'You\'re welcome! Please let me know if you have any other questions.';
    } else if (lowerMessage.contains('book') ||
        lowerMessage.contains('reserve')) {
      return 'Great! To confirm your booking, please make a 25% advance payment through the app. Would you like me to send you the booking link?';
    }

    return 'Thank you for your message. I\'ll get back to you shortly with more details!';
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inHours > 0) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return 'Just now';
    }
  }

  bool _shouldShowTimestamp(int index) {
    if (index == 0) return true;

    final currentMessage = _messages[index];
    final previousMessage = _messages[index - 1];

    final currentTime = currentMessage['timestamp'] as DateTime;
    final previousTime = previousMessage['timestamp'] as DateTime;

    // Show timestamp if more than 30 minutes between messages
    return currentTime.difference(previousTime).inMinutes > 30;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.owner['image']),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Column(
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
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Calling owner...')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsBottomSheet();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _messages.isEmpty
                    ? _buildEmptyState()
                    : _buildMessagesList(),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withAlpha(
                    25,
                  ), // equivalent to opacity 0.1
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      _showAttachmentOptions();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 5,
                      onSubmitted: (_) {
                        _sendMessage();
                      },
                    ),
                  ),
                  IconButton(
                    icon:
                        _isSending
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    onPressed: _isSending ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to start the conversation',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isUser = message['sender'] == 'user';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_shouldShowTimestamp(index))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatTimestamp(message['timestamp'] as DateTime),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
            _buildMessageBubble(message, isUser),
          ],
        );
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isUser) {
    final isPending = message['isPending'] == true;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color:
                isUser
                    ? Theme.of(context).primaryColor.withAlpha(
                      230,
                    ) // equivalent to opacity 0.9
                    : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20.0).copyWith(
              bottomRight: isUser ? const Radius.circular(5.0) : null,
              bottomLeft: !isUser ? const Radius.circular(5.0) : null,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message['text'],
                style: TextStyle(color: isUser ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message['timestamp'] as DateTime),
                    style: TextStyle(
                      fontSize: 10,
                      color: isUser ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  if (isUser && !isPending)
                    Icon(
                      message['isRead'] ? Icons.done_all : Icons.done,
                      size: 12,
                      color: Colors.white70,
                    ),
                  if (isUser && isPending)
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.white70,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Share Attachment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    context,
                    Icons.photo,
                    'Gallery',
                    Colors.purple,
                  ),
                  _buildAttachmentOption(
                    context,
                    Icons.camera_alt,
                    'Camera',
                    Colors.red,
                  ),
                  _buildAttachmentOption(
                    context,
                    Icons.insert_drive_file,
                    'Document',
                    Colors.blue,
                  ),
                  _buildAttachmentOption(
                    context,
                    Icons.location_on,
                    'Location',
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label option coming soon!')));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(25), // equivalent to opacity 0.1
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.grey[800], fontSize: 12)),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Property'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/listing_detail',
                  arguments: {'id': 'from_chat', 'name': widget.propertyName},
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
                _showBlockDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report User'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Report functionality coming soon'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text('Clear Chat'),
              onTap: () {
                Navigator.pop(context);
                _showClearChatDialog();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Block User'),
          content: Text(
            'Are you sure you want to block ${widget.owner['name']}? You will no longer receive messages from this user.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User blocked successfully')),
                );
              },
              child: const Text('Block', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Chat'),
          content: const Text(
            'Are you sure you want to clear all messages? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _messages.clear();
                });
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Chat cleared')));
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
