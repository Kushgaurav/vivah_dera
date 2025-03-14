import 'package:flutter/material.dart';

class OwnerListingsScreen extends StatefulWidget {
  const OwnerListingsScreen({super.key});

  @override
  State<OwnerListingsScreen> createState() => _OwnerListingsScreenState();
}

class _OwnerListingsScreenState extends State<OwnerListingsScreen> {
  // Sample data for listings
  final List<Map<String, dynamic>> _listings = [
    {
      'name': 'Royal Garden Hall',
      'address': 'Sector 10, Panchkula',
      'price': '₹75,000',
      'rating': 4.8,
      'reviewCount': 42,
      'image':
          'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?ixlib=rb-4.0.3',
      'isActive': true,
    },
    {
      'name': 'Golden Palace',
      'address': 'Phase 7, Mohali',
      'price': '₹95,000',
      'rating': 4.5,
      'reviewCount': 38,
      'image':
          'https://images.unsplash.com/photo-1464817739973-0128fe77aaa1?ixlib=rb-4.0.3',
      'isActive': true,
    },
    {
      'name': 'Silver Jubilee Banquet',
      'address': 'Manimajra, Chandigarh',
      'price': '₹65,000',
      'rating': 4.2,
      'reviewCount': 27,
      'image':
          'https://images.unsplash.com/photo-1519741347686-c1e0aadf4611?ixlib=rb-4.0.3',
      'isActive': false,
    },
    {
      'name': 'Emerald Gardens',
      'address': 'Sector 35, Chandigarh',
      'price': '₹85,000',
      'rating': 4.7,
      'reviewCount': 52,
      'image':
          'https://images.unsplash.com/photo-1505236858219-8359eb29e329?ixlib=rb-4.0.3',
      'isActive': true,
    },
    {
      'name': 'Sunshine Resorts',
      'address': 'Zirakpur, Punjab',
      'price': '₹55,000',
      'rating': 4.0,
      'reviewCount': 18,
      'image':
          'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?ixlib=rb-4.0.3',
      'isActive': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [Tab(text: 'Active'), Tab(text: 'Inactive')],
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepPurple,
          ),
          Expanded(
            child: TabBarView(
              children: [_buildListingsList(true), _buildListingsList(false)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingsList(bool isActive) {
    final filteredListings =
        _listings.where((listing) => listing['isActive'] == isActive).toList();

    if (filteredListings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.home_outlined : Icons.home_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isActive
                  ? 'No active listings found'
                  : 'No inactive listings found',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            if (!isActive)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/listing_editor');
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Listing'),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredListings.length,
      itemBuilder: (context, index) {
        final listing = filteredListings[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Venue Image with Status Badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      listing['image'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Inactive',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Venue Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            listing['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          listing['price'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          listing['address'],
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${listing['rating']} (${listing['reviewCount']} reviews)',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/listing_editor',
                                arguments: {'listingId': listing['id']},
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                listing['isActive'] = !listing['isActive'];
                              });
                            },
                            icon: Icon(
                              isActive
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            label: Text(isActive ? 'Deactivate' : 'Activate'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isActive ? Colors.redAccent : Colors.green,
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
        );
      },
    );
  }
}
