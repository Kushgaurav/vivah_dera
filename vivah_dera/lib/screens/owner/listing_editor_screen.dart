import 'package:flutter/material.dart';

class ListingEditorScreen extends StatefulWidget {
  final bool isEditing;
  final String? listingId;

  const ListingEditorScreen({
    super.key,
    required this.isEditing,
    this.listingId,
  });

  @override
  State<ListingEditorScreen> createState() => _ListingEditorScreenState();
}

class _ListingEditorScreenState extends State<ListingEditorScreen> {
  // Form controllers and variables
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isSaving = false;

  // Basic info controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  final _priceController = TextEditingController();
  final _capacityMinController = TextEditingController();
  final _capacityMaxController = TextEditingController();

  // Location controllers
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _landmarkController = TextEditingController();

  // Amenities and Rules
  final List<String> _availableAmenities = [
    'Air Conditioning',
    'Parking',
    'Sound System',
    'Outdoor Space',
    'Catering',
    'Wi-Fi',
    'Stage',
    'DJ Equipment',
    'Decoration',
    'Security',
    'Wheelchair Access',
    'Restrooms',
    'Power Backup',
  ];
  final List<String> _selectedAmenities = [];
  final List<TextEditingController> _rulesControllers = [
    TextEditingController(),
  ];

  // Image URLs (in a real app, we'd upload images to storage)
  final List<String> _imageUrls = [];

  // Category options
  final List<String> _categories = [
    'Wedding Hall',
    'Tent House',
    'Farmhouse',
    'Conference Room',
    'Banquet Hall',
    'Party Plot',
    'Resort',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadListingData();
    }
  }

  void _loadListingData() {
    setState(() {
      _isLoading = true;
    });

    // In a real app, we'd fetch data from Firestore or other database
    // For now, let's simulate loading with mock data
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        // Populate form with mock data
        _titleController.text = 'Luxury Wedding Hall';
        _descriptionController.text =
            'A beautiful venue for all your special occasions';
        _selectedCategory = 'Wedding Hall';
        _priceController.text = '45000';
        _capacityMinController.text = '100';
        _capacityMaxController.text = '500';

        _addressController.text = '123, Green Garden Road';
        _cityController.text = 'Delhi';
        _stateController.text = 'Delhi';
        _pincodeController.text = '110001';
        _landmarkController.text = 'Near City Park';

        _selectedAmenities.addAll([
          'Air Conditioning',
          'Parking',
          'Sound System',
          'Catering',
          'Wi-Fi',
        ]);

        _rulesControllers.clear();
        for (var rule in [
          'No smoking indoors',
          'Music until 10:00 PM only',
          'No outside catering',
        ]) {
          _rulesControllers.add(TextEditingController(text: rule));
        }

        _imageUrls.addAll([
          'https://source.unsplash.com/random/800x600?wedding,hall&sig=1',
          'https://source.unsplash.com/random/800x600?wedding,venue&sig=2',
        ]);

        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _capacityMinController.dispose();
    _capacityMaxController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    for (var controller in _rulesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    // Add your pop logic here
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        setState(() {
          _currentStep--;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? 'Edit Venue' : 'Add New Venue'),
          leading: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                _onWillPop().then((shouldPop) {
                  if (shouldPop && context.mounted) Navigator.of(context).pop();
                });
              }
            },
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                final shouldPop = await _onWillPop();
                if (shouldPop && context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          actions: [
            if (_currentStep == 3) // Preview button on last step
              TextButton.icon(
                onPressed: _previewListing,
                icon: const Icon(Icons.preview),
                label: const Text('Preview'),
              ),
          ],
        ),
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Step indicators
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            _buildStepIndicator(0, 'Basics'),
                            _buildStepDivider(0),
                            _buildStepIndicator(1, 'Location'),
                            _buildStepDivider(1),
                            _buildStepIndicator(2, 'Features'),
                            _buildStepDivider(2),
                            _buildStepIndicator(3, 'Photos'),
                          ],
                        ),
                      ),

                      // Step content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: _buildCurrentStepContent(),
                        ),
                      ),

                      // Navigation buttons
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                13,
                              ), // equivalent to opacity 0.05
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentStep > 0)
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentStep--;
                                  });
                                },
                                child: const Text('Back'),
                              )
                            else
                              const SizedBox(),
                            _isSaving
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                  onPressed:
                                      _currentStep < 3
                                          ? _nextStep
                                          : _saveListing,
                                  child: Text(
                                    _currentStep < 3 ? 'Next' : 'Save Listing',
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
            ),
            child: Center(
              child: Text(
                (step + 1).toString(),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade600,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(int beforeStep) {
    final isActive = _currentStep > beforeStep;
    return Expanded(
      child: Container(
        height: 2,
        color:
            isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildLocationStep();
      case 2:
        return _buildFeaturesStep();
      case 3:
        return _buildPhotosStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Basic Information'),

        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Venue Name',
            hintText: 'Enter the name of your venue',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name for your venue';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          items:
              _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a category';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Tell renters about your venue',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            if (value.length < 50) {
              return 'Description should be at least 50 characters';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        _buildSectionTitle('Pricing & Capacity'),

        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'Price per day (₹)',
            hintText: 'Enter price in rupees',
            border: OutlineInputBorder(),
            prefixText: '₹ ',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a price';
            }
            if (int.tryParse(value) == null || int.parse(value) <= 0) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _capacityMinController,
                decoration: const InputDecoration(
                  labelText: 'Minimum Capacity',
                  hintText: 'Min. guests',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _capacityMaxController,
                decoration: const InputDecoration(
                  labelText: 'Maximum Capacity',
                  hintText: 'Max. guests',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid';
                  }
                  final min = int.tryParse(_capacityMinController.text) ?? 0;
                  final max = int.tryParse(value) ?? 0;
                  if (max < min) {
                    return 'Must be ≥ min';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Location Details'),

        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address Line',
            hintText: 'Street address',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an address';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _pincodeController,
          decoration: const InputDecoration(
            labelText: 'PIN Code',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter PIN code';
            }
            if (value.length != 6 || int.tryParse(value) == null) {
              return 'Please enter a valid 6-digit PIN code';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _landmarkController,
          decoration: const InputDecoration(
            labelText: 'Landmark (Optional)',
            hintText: 'Nearby landmark to help find the location',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 24),

        _buildSectionTitle('Map Location'),

        const SizedBox(height: 8),

        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Map integration coming soon',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // Map functionality would be implemented here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Map pin functionality coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.location_pin),
                  label: const Text('Pin Location'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Amenities'),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              _availableAmenities.map((amenity) {
                final isSelected = _selectedAmenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAmenities.add(amenity);
                      } else {
                        _selectedAmenities.remove(amenity);
                      }
                    });
                  },
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  checkmarkColor: Theme.of(context).colorScheme.primary,
                );
              }).toList(),
        ),

        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Rules & Policies'),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _rulesControllers.add(TextEditingController());
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Rule'),
            ),
          ],
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _rulesControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rulesControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Rule ${index + 1}',
                        hintText: 'Enter a rule or policy',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a rule or delete this field';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (_rulesControllers.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _rulesControllers.removeAt(index);
                        });
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPhotosStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Photos'),

        const Text(
          'Add photos of your venue (minimum 1 photo required)',
          style: TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: _imageUrls.length + 1, // +1 for the add button
          itemBuilder: (context, index) {
            if (index == _imageUrls.length) {
              // Add photo button
              return InkWell(
                onTap: _addNewImage,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 32,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Existing photo
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _imageUrls[index],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _imageUrls.removeAt(index);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(
                            204,
                          ), // equivalent to opacity 0.8
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.tips_and_updates, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Tips for Better Listings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Add high-quality photos of different areas of your venue\n'
                '• Include photos of both interior and exterior spaces\n'
                '• Show the venue with proper lighting and decoration\n'
                '• Add photos that highlight your unique amenities',
                style: TextStyle(color: Colors.blue.shade800, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_validateBasicInfo()) return;
    } else if (_currentStep == 1) {
      if (!_validateLocationInfo()) return;
    } else if (_currentStep == 2) {
      if (!_validateFeaturesInfo()) return;
    }

    setState(() {
      _currentStep++;
    });
  }

  bool _validateBasicInfo() {
    if (_titleController.text.isEmpty) {
      _showValidationError('Please enter a venue name');
      return false;
    }
    if (_selectedCategory == null) {
      _showValidationError('Please select a category');
      return false;
    }
    if (_descriptionController.text.length < 50) {
      _showValidationError('Description should be at least 50 characters');
      return false;
    }
    if (_priceController.text.isEmpty ||
        int.tryParse(_priceController.text) == null) {
      _showValidationError('Please enter a valid price');
      return false;
    }
    if (_capacityMinController.text.isEmpty ||
        int.tryParse(_capacityMinController.text) == null) {
      _showValidationError('Please enter a valid minimum capacity');
      return false;
    }
    if (_capacityMaxController.text.isEmpty ||
        int.tryParse(_capacityMaxController.text) == null) {
      _showValidationError('Please enter a valid maximum capacity');
      return false;
    }

    final minCapacity = int.parse(_capacityMinController.text);
    final maxCapacity = int.parse(_capacityMaxController.text);
    if (maxCapacity < minCapacity) {
      _showValidationError(
        'Maximum capacity cannot be less than minimum capacity',
      );
      return false;
    }

    return true;
  }

  bool _validateLocationInfo() {
    if (_addressController.text.isEmpty) {
      _showValidationError('Please enter an address');
      return false;
    }
    if (_cityController.text.isEmpty) {
      _showValidationError('Please enter a city');
      return false;
    }
    if (_stateController.text.isEmpty) {
      _showValidationError('Please enter a state');
      return false;
    }
    if (_pincodeController.text.isEmpty ||
        _pincodeController.text.length != 6 ||
        int.tryParse(_pincodeController.text) == null) {
      _showValidationError('Please enter a valid 6-digit PIN code');
      return false;
    }
    return true;
  }

  bool _validateFeaturesInfo() {
    if (_selectedAmenities.isEmpty) {
      _showValidationError('Please select at least one amenity');
      return false;
    }

    for (var controller in _rulesControllers) {
      if (controller.text.isEmpty) {
        _showValidationError('Please fill in all rules or remove empty fields');
        return false;
      }
    }

    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _addNewImage() {
    // In a real app, we would show an image picker and upload to storage
    // For demo purposes, we'll add a random image URL
    setState(() {
      final index = _imageUrls.length + 1;
      _imageUrls.add(
        'https://source.unsplash.com/random/800x600?venue&sig=$index',
      );
    });
  }

  void _previewListing() {
    // In a real app, we would show a preview of how the listing will appear to renters
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Listing Preview'),
            content: const Text(
              'Preview functionality will be implemented in future updates.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _saveListing() {
    // Final validation
    if (_imageUrls.isEmpty) {
      _showValidationError('Please add at least one photo');
      return;
    }

    // Save listing (would normally send to backend/Firestore)
    setState(() {
      _isSaving = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Success'),
              content: Text(
                widget.isEditing
                    ? 'Your listing has been updated successfully!'
                    : 'Your new listing has been created successfully!',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to previous screen
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    });
  }
}
