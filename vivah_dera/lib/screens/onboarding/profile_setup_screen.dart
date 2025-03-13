import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSetupScreen extends StatefulWidget {
  final String userType; // 'renter' or 'owner'
  
  const ProfileSetupScreen({Key? key, this.userType = 'renter'}) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Personal information
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;
  
  // Address information
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  
  // Preferences (for renter)
  final List<String> _selectedInterests = [];
  String? _selectedNotificationPref;
  
  // Business information (for owner)
  final _businessNameController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  
  final List<String> _interestOptions = [
    'Weddings', 'Birthday Parties', 'Corporate Events',
    'Engagement', 'Conference', 'Reception'
  ];
  
  bool _isSubmitting = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }
  
  void _nextStep() {
    if (_currentStep == 0) {
      // Validate personal information
      if (!_formKey.currentState!.validate() || _selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all required fields')),
        );
        return;
      }
    } else if (_currentStep == 1) {
      // Validate address information
      if (!_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all required fields')),
        );
        return;
      }
    } else if (_currentStep == 2) {
      // Validate preferences/business info
      if (widget.userType == 'owner' && !_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all required fields')),
        );
        return;
      }
      
      if (widget.userType == 'renter' && _selectedInterests.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one interest')),
        );
        return;
      }
      
      _submitProfile();
      return;
    }
    
    setState(() {
      _currentStep++;
    });
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }
  
  void _submitProfile() {
    setState(() {
      _isSubmitting = true;
    });
    
    // Simulate profile submission
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      setState(() {
        _isSubmitting = false;
      });
      
      Navigator.pushReplacementNamed(
        context, 
        widget.userType == 'owner' ? '/owner_dashboard' : '/renter_home'
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your ${widget.userType == 'owner' ? 'Business ' : ''}Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Stepper indicator
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1, 2].map((index) {
                  final isActive = index == _currentStep;
                  final isCompleted = index < _currentStep;
                  
                  return Row(
                    children: [
                      if (index > 0)
                        Container(
                          width: 20,
                          height: 2,
                          color: isCompleted || index <= _currentStep
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                        ),
                      Column(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive 
                                  ? Theme.of(context).primaryColor 
                                  : isCompleted 
                                    ? Theme.of(context).primaryColor.withOpacity(0.7)
                                    : Colors.grey[300],
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: isActive ? Colors.white : Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            index == 0
                                ? 'Personal'
                                : index == 1
                                    ? 'Address'
                                    : widget.userType == 'owner'
                                        ? 'Business'
                                        : 'Preferences',
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive || isCompleted
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[600],
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            
            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),
            
            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: _previousStep,
                      child: const Text('Previous'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting 
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(_currentStep < 2 ? 'Next' : 'Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildPersonalInfoForm();
      case 1: return _buildAddressForm();
      case 2: return widget.userType == 'owner' 
          ? _buildBusinessInfoForm() 
          : _buildPreferencesForm();
      default: return const SizedBox.shrink();
    }
  }
  
  Widget _buildPersonalInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: _profileImage != null 
                    ? FileImage(_profileImage!) 
                    : null,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        const Text(
          'Gender',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Male'),
                value: 'male',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Female'),
                value: 'female',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
          ],
        ),
        RadioListTile<String>(
          title: const Text('Other'),
          value: 'other',
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
      ],
    );
  }
  
  Widget _buildAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _addressController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.home_outlined),
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'City',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_city_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your city';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _stateController,
          decoration: const InputDecoration(
            labelText: 'State',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.map_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your state';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _pincodeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'PIN Code',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.pin_drop_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your PIN code';
            }
            if (value.length != 6) {
              return 'PIN code must be 6 digits';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  Widget _buildPreferencesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What type of venues are you interested in?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interestOptions.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedInterests.add(interest);
                  } else {
                    _selectedInterests.remove(interest);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        
        const Text(
          'Notification Preferences',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        RadioListTile<String>(
          title: const Text('All notifications'),
          subtitle: const Text('Get notified about all updates and offers'),
          value: 'all',
          groupValue: _selectedNotificationPref,
          onChanged: (value) {
            setState(() {
              _selectedNotificationPref = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          title: const Text('Important only'),
          subtitle: const Text('Only get notified about bookings and important updates'),
          value: 'important',
          groupValue: _selectedNotificationPref,
          onChanged: (value) {
            setState(() {
              _selectedNotificationPref = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          title: const Text('Minimal'),
          subtitle: const Text('Only receive booking-related notifications'),
          value: 'minimal',
          groupValue: _selectedNotificationPref,
          onChanged: (value) {
            setState(() {
              _selectedNotificationPref = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
  
  Widget _buildBusinessInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _businessNameController,
          decoration: const InputDecoration(
            labelText: 'Business Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your business name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _businessDescriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Business Description',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.description_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your business description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        const Text(
          'Business Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Wedding Hall', 'Banquet Hall', 'Conference Center',
            'Farmhouse', 'Resort', 'Tent House'
          ].map((category) {
            return ChoiceChip(
              label: Text(category),
              selected: category == 'Wedding Hall', // Default selection
              onSelected: (selected) {
                // Logic to select only one chip
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: category == 'Wedding Hall'
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 32),
        
        const Text(
          'Other Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        CheckboxListTile(
          value: true,
          onChanged: (value) {},
          title: const Text('I have GST registration'),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: false,
          onChanged: (value) {},
          title: const Text('I have proper business license'),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}
