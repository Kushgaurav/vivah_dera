import 'package:flutter/material.dart';

class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({Key? key}) : super(key: key);

  @override
  _ListingDetailScreenState createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> with TickerProviderStateMixin {
  bool isFavorite = false;
  late TabController _tabController;
  final List<String> _galleryImages = [
    'https://source.unsplash.com/random/800x600?wedding+hall',
    'https://source.unsplash.com/random/800x600?banquet',
    'https://source.unsplash.com/random/800x600?dining',
    'https://source.unsplash.com/random/800x600?stage',
    'https://source.unsplash.com/random/800x600?decoration',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the property data passed from the previous screen
    final Map<String, dynamic> property =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    // Initialize favorite status from property data
    isFavorite = property['isFavorite'] ?? false;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(property),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... existing code ...
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Reviews'),
                    Tab(text: 'Amenities'),
                  ],
                ),
                SizedBox(
                  height: 500, // Fixed height for tab content
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(property),
                      _buildReviewsTab(),
                      _buildAmenitiesTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        // ... existing code ...
      ),
    );
  }

  Widget _buildAppBar(Map<String, dynamic> property) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              itemCount: _galleryImages.length,
              itemBuilder: (context, index) {
                return Image.network(
                  _galleryImages[index],
                  fit: BoxFit.cover,
                );
              },
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '1/${_galleryImages.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Share this listing
          },
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> property) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This beautiful venue offers a perfect backdrop for your special occasion. With spacious interiors, modern amenities, and professional staff, we ensure your event is memorable and hassle-free. The venue features multiple halls that can accommodate various group sizes, lush gardens for outdoor ceremonies, and state-of-the-art sound systems.',
            style: TextStyle(
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Host Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://source.unsplash.com/random/100x100?person',
              ),
            ),
            title: const Text('Raj Singh'),
            subtitle: const Text('Superhost · 4 years hosting'),
            trailing: IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {
                // TODO: Navigate to chat with owner
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            child: const Center(
              child: Text('Map will be displayed here'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://source.unsplash.com/random/100x100?person=${index + 1}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'July ${10 + index}, 2023',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text('${4 + (index % 2 == 0 ? 0.5 : 0)}'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Had a wonderful experience. The venue was beautiful, the staff was helpful, and everything went smoothly for our event.',
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 8),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmenitiesTab() {
    final amenities = [
      {'icon': Icons.wifi, 'name': 'Free Wi-Fi'},
      {'icon': Icons.local_parking, 'name': 'Free Parking'},
      {'icon': Icons.ac_unit, 'name': 'Air Conditioning'},
      {'icon': Icons.restaurant, 'name': 'In-house Catering'},
      {'icon': Icons.music_note, 'name': 'Sound System'},
      {'icon': Icons.local_bar, 'name': 'Bar Services'},
      {'icon': Icons.security, 'name': '24/7 Security'},
      {'icon': Icons.accessibility, 'name': 'Wheelchair Accessible'},
      {'icon': Icons.deck, 'name': 'Outdoor Space'},
      {'icon': Icons.video_camera_back, 'name': 'AV Equipment'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(amenities[index]['icon'] as IconData),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  amenities[index]['name'] as String,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
