import 'package:flutter/material.dart';
import 'package:vivah_dera/screens/owner/listing_editor_screen.dart';

class OwnerListingsScreen extends StatefulWidget {
  const OwnerListingsScreen({super.key});

  @override
  State<OwnerListingsScreen> createState() => _OwnerListingsScreenState();
}

class _OwnerListingsScreenState extends State<OwnerListingsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _listings = [];

  @override
  void initState() {
    super.initState();
    _loadListings();
  }

  void _loadListings() {
    // Simulate loading from API or database
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _listings = [
          {
            'id': 'venue-001',
            'title': 'Royal Wedding Hall',
            'location': 'Sector 28, Delhi',
            'price': '₹45,000',
            'capacity': '500',
            'rating': 4.7,
            'image':
                'https://source.unsplash.com/random/800x600?wedding,hall&sig=1',
            'bookingCount': 12,
            'isActive': true,
            'category': 'Wedding Hall',
          },
          {
            'id': 'venue-002',
            'title': 'Garden Party Venue',
            'location': 'MG Road, Gurgaon',
            'price': '₹35,000',
            'capacity': '300',
            'rating': 4.5,
            'image':
                'https://source.unsplash.com/random/800x600?garden,party&sig=2',
            'bookingCount': 8,
            'isActive': true,
            'category': 'Party Plot',
          },
          {
            'id': 'venue-003',
            'title': 'Conference Center',
            'location': 'Connaught Place, Delhi',
            'price': '₹25,000',
            'capacity': '100',
            'rating': 4.3,
            'image':
                'https://source.unsplash.com/random/800x600?conference&sig=3',
            'bookingCount': 5,
            'isActive': false,
            'category': 'Conference Room',
          },
        ];
        _isLoading = false;
      });
    });
  }

  void _deleteListing(String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Listing'),
            content: const Text(
              'Are you sure you want to delete this property? This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Delete listing
                  setState(() {
                    _listings.removeWhere((listing) => listing['id'] == id);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Property has been deleted')),
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _toggleListingStatus(String id, bool isActive) {
    setState(() {
      for (final listing in _listings) {
        if (listing['id'] == id) {
          listing['isActive'] = !isActive;
          break;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isActive ? 'Property has been deactivated' : 'Property is now live',
        ),
      ),
    );
  }

  Future<void> _editListing(String id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ListingEditorScreen(isEditing: true, listingId: id),
      ),
    );
    // In a real app, we would refresh the listing data here
  }

  Future<void> _addNewListing() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ListingEditorScreen(isEditing: false),
      ),
    );
    // In a real app, we would refresh the listing data here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter options coming soon')),
              );
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _listings.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _listings.length,
                itemBuilder: (context, index) {
                  final listing = _listings[index];
                  return _buildListingCard(listing);
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewListing,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_work, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Properties Listed',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first property to start accepting bookings',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addNewListing,
            icon: const Icon(Icons.add),
            label: const Text('Add New Property'),
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image and status badge
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  listing['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, size: 50),
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
                    color: listing['isActive'] ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    listing['isActive'] ? 'Active' : 'Inactive',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    listing['category'],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          // Property details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  listing['title'],
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      listing['location'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Capacity
                Row(
                  children: [
                    const Icon(Icons.people, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Capacity: ${listing['capacity']} guests',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    // Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            listing['price'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bookings
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bookings',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '${listing['bookingCount']} bookings',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    // Rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rating',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                listing['rating'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    // Edit button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editListing(listing['id']),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Delete button
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteListing(listing['id']),
                    ),

                    const SizedBox(width: 8),

                    // Toggle active status
                    Switch(
                      value: listing['isActive'],
                      onChanged:
                          (value) => _toggleListingStatus(
                            listing['id'],
                            listing['isActive'],
                          ),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
