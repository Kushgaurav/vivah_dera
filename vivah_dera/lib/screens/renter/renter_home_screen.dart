import 'package:flutter/material.dart';
import '../../widgets/property_card.dart';

class RenterHomeScreen extends StatefulWidget {
  const RenterHomeScreen({Key? key}) : super(key: key);

  @override
  _RenterHomeScreenState createState() => _RenterHomeScreenState();
}

class _RenterHomeScreenState extends State<RenterHomeScreen> {
  int _currentIndex = 0;
  final List<String> _categories = [
    'All',
    'Wedding',
    'Birthday',
    'Corporate',
    'Engagement',
    'Parties',
    'Conference'
  ];
  int _selectedCategoryIndex = 0;
  final List<Map<String, dynamic>> _mockProperties = [
    {
      'imageUrl': 'https://source.unsplash.com/random/300x200?wedding+hall',
      'title': 'Royal Wedding Palace',
      'location': 'Sector 18, Chandigarh',
      'price': 50000,
      'rating': 4.8,
      'category': 'Wedding',
      'isFavorite': false,
    },
    {
      'imageUrl': 'https://source.unsplash.com/random/300x200?banquet',
      'title': 'Luxury Banquet Hall',
      'location': 'Phase 7, Mohali',
      'price': 35000,
      'rating': 4.5,
      'category': 'Birthday',
      'isFavorite': true,
    },
    {
      'imageUrl': 'https://source.unsplash.com/random/300x200?conference',
      'title': 'Business Conference Center',
      'location': 'Industrial Area, Panchkula',
      'price': 25000,
      'rating': 4.2,
      'category': 'Corporate',
      'isFavorite': false,
    },
    {
      'imageUrl': 'https://source.unsplash.com/random/300x200?party+hall',
      'title': 'Celebration Garden',
      'location': 'Zirakpur, Punjab',
      'price': 40000,
      'rating': 4.6,
      'category': 'Engagement',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // For now, only implement the Home tab
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const Center(child: Text('Search Tab - Coming Soon'));
      case 2:
        return const Center(child: Text('Bookings Tab - Coming Soon'));
      case 3:
        return const Center(child: Text('Messages Tab - Coming Soon'));
      case 4:
        return const Center(child: Text('Profile Tab - Coming Soon'));
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://source.unsplash.com/random/100x100?person'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Renter',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Find your perfect venue',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Navigate to notifications
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for venues...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onTap: () {
                      // TODO: Navigate to search page
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Category selector
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Venues',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final property = _mockProperties[index];
                  return PropertyCard(
                    imageUrl: property['imageUrl'],
                    title: property['title'],
                    location: property['location'],
                    price: property['price'],
                    rating: property['rating'],
                    category: property['category'],
                    isFavorite: property['isFavorite'],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/listing_detail',
                        arguments: property,
                      );
                    },
                    onFavoriteToggle: (isFavorite) {
                      setState(() {
                        _mockProperties[index]['isFavorite'] = isFavorite;
                      });
                    },
                  );
                },
                childCount: _mockProperties.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Nearby',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _mockProperties.length,
                itemBuilder: (context, index) {
                  final property = _mockProperties[index];
                  return Container(
                    width: 260,
                    margin: const EdgeInsets.only(right: 16),
                    child: PropertyCard(
                      imageUrl: property['imageUrl'],
                      title: property['title'],
                      location: property['location'],
                      price: property['price'],
                      rating: property['rating'],
                      category: property['category'],
                      isFavorite: property['isFavorite'],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/listing_detail',
                          arguments: property,
                        );
                      },
                      onFavoriteToggle: (isFavorite) {
                        setState(() {
                          _mockProperties[index]['isFavorite'] = isFavorite;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
