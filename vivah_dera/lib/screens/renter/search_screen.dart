import 'package:flutter/material.dart';
import 'package:vivah_dera/widgets/property_card.dart';
import 'package:vivah_dera/screens/renter/listing_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isFilterVisible = false;
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(10000, 100000);

  final List<String> _categories = [
    'All',
    'Wedding Halls',
    'Tent Houses',
    'Farmhouses',
    'Conference Rooms',
    'Banquet Halls',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search for venues...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: _onSearchSubmitted,
                )
                : const Text('Search'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _isFilterVisible = !_isFilterVisible;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'List View'), Tab(text: 'Map View')],
        ),
      ),
      body: Column(
        children: [
          // Filter section
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isFilterVisible ? 230 : 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Category',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            _categories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: _selectedCategory == category,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Price Range',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: _priceRange,
                      min: 5000,
                      max: 200000,
                      divisions: 39,
                      labels: RangeLabels(
                        '₹${_priceRange.start.round()}',
                        '₹${_priceRange.end.round()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('₹5,000'), Text('₹200,000')],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search results
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // List View
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PropertyCard(
                        imageUrl:
                            'https://source.unsplash.com/random/300x200?venue&sig=$index',
                        title: 'Venue Name ${index + 1}',
                        location: 'Location ${index + 1}',
                        price: 20000 + (index * 5000),
                        rating: 4.0 + (index % 10) / 10,
                        category: _selectedCategory,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ListingDetailScreen(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                // Map View
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map, size: 100, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Map View Coming Soon',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We\'re working on adding an interactive map to help you find venues near you.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _isSearching = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _isFilterVisible = false;
    });
  }
}
