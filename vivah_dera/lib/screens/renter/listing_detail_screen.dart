import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({super.key});

  @override
  State<ListingDetailScreen> createState() => ListingDetailScreenState();
}

class ListingDetailScreenState extends State<ListingDetailScreen> {
  bool _isFavorite = false;
  late Map<String, dynamic> _venueData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract arguments passed from previous screen
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _venueData = args;
      _isFavorite = _venueData['isFavorite'] ?? false;
    } else {
      // Fallback data if no arguments are passed
      _venueData = {
        'imageUrl': 'https://source.unsplash.com/random/800x600?wedding+hall',
        'title': 'Royal Wedding Palace',
        'location': 'Sector 18, Chandigarh',
        'price': 50000,
        'rating': 4.8,
        'category': 'Wedding',
        'description': 'A luxurious venue for your special occasions.',
        'capacity': '100-500 guests',
        'amenities': ['Parking', 'AC', 'Kitchen', 'Décor', 'Catering'],
        'isFavorite': false,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVenueHeader(),
                  const SizedBox(height: 16),
                  _buildDetailsCard(),
                  const SizedBox(height: 16),
                  _buildDescriptionCard(),
                  const SizedBox(height: 16),
                  _buildAmenitiesCard(),
                  const SizedBox(height: 16),
                  _buildLocationCard(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Reviews'),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      _buildReviewCard(
                        name: "Rajiv Sharma",
                        rating: 4.5,
                        date: "2 weeks ago",
                        comment:
                            "Beautiful venue with excellent facilities. The staff was very accommodating and helpful throughout the event.",
                      ),
                      _buildReviewCard(
                        name: "Priya Singh",
                        rating: 5.0,
                        date: "1 month ago",
                        comment:
                            "Perfect location for our wedding. Spacious, well-maintained, and the catering service was outstanding. Highly recommended!",
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _venueData['imageUrl'] ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 100),
                );
              },
            ),
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(128), // equivalent to opacity 0.5
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isFavorite ? 'Added to favorites' : 'Removed from favorites',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            // Implement share functionality
            _shareVenue(_venueData['title'], _venueData['location']);
          },
        ),
      ],
    );
  }

  Widget _buildVenueHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _venueData['title'] ?? 'Venue Title',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              _venueData['location'] ?? 'Venue Location',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              '${_venueData['rating'] ?? 0} (${_venueData['reviewCount'] ?? 0} reviews)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16, height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).primaryColor.withAlpha(51), // equivalent to opacity 0.2
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _venueData['category'] ?? 'Category',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  Icons.people_outline,
                  'Capacity',
                  _venueData['capacity'] ?? '100-500',
                ),
                _buildDetailItem(
                  Icons.attach_money,
                  'Starting Price',
                  '₹${_venueData['price'] ?? 0}',
                ),
                _buildDetailItem(
                  Icons.calendar_today_outlined,
                  'Availability',
                  'Check Calendar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _venueData['description'] ??
                  'This beautiful venue offers state-of-the-art facilities for your events. With spacious halls and beautiful decor, it makes for a perfect setting for weddings, corporate events, and other celebrations.',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesCard() {
    final List<String> amenities = List<String>.from(
      _venueData['amenities'] ?? ['Parking', 'WiFi', 'Catering', 'AC'],
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Amenities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  amenities.map((amenity) {
                    return Chip(
                      label: Text(amenity),
                      avatar: const Icon(Icons.check_circle, size: 16),
                      backgroundColor: Colors.grey.shade100,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelStyle: const TextStyle(fontSize: 12),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 150,
                color: Colors.grey.shade300,
                width: double.infinity,
                child: const Center(child: Text('Map will be displayed here')),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _venueData['location'] ?? 'Venue Location',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Open in maps
                    _openInMaps(_venueData['location']);
                  },
                  child: const Text('Get Directions'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51), // equivalent to opacity 0.2
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Price', style: TextStyle(color: Colors.grey)),
              Text(
                '₹${_venueData['price'] ?? 0}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                'per day',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/booking', arguments: _venueData);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  void _shareVenue(String? venueTitle, String? venueLocation) {
    // Implementation for sharing venue
    // Use Share package or show a modal with sharing options
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing $venueTitle at $venueLocation')),
    );
  }

  void _openInMaps(String location) async {
    // Implementation for opening location in maps
    final latitude = _venueData['latitude'];
    final longitude = _venueData['longitude'];
    final title = _venueData['title'];

    // Launch maps URL with coordinates
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place_id=$title';
    await _launchMapsUrl(url);
  }

  Future<void> _launchMapsUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Utility methods - marked to prevent unused warnings
  @pragma('vm:entry-point')
  Future<void> _openExternalLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @pragma('vm:entry-point')
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @pragma('vm:entry-point')
  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $email';
    }
  }

  Widget _buildReviewCard({
    required String name,
    required double rating,
    required String date,
    required String comment,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(rating.toString()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(date, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(comment),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
