import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSetupScreen extends StatefulWidget {
  final String userType; // 'renter' or 'owner'

  const ProfileSetupScreen({super.key, this.userType = 'renter'});

  @override
  State<ProfileSetupScreen> createState() => ProfileSetupScreenState();
}

class ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _currentStep = 0;

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

  // Business information (for owner)
  final _businessNameController = TextEditingController();
  final _businessDescriptionController = TextEditingController();

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

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  void _pickProfileImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _previousStep,
        steps: _buildSteps(),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                OutlinedButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(
                  _currentStep < _buildSteps().length - 1 ? 'Next' : 'Submit',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Personal Info'),
        content: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
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
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items:
                  ['Male', 'Female', 'Other'].map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select your gender';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child:
                    _profileImage == null
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
              ),
            ),
          ],
        ),
        isActive: _currentStep == 0,
      ),
      Step(
        title: const Text('Address Info'),
        content: Column(
          children: [
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.home_outlined),
                border: OutlineInputBorder(),
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
                prefixIcon: Icon(Icons.location_city_outlined),
                border: OutlineInputBorder(),
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
                prefixIcon: Icon(Icons.map_outlined),
                border: OutlineInputBorder(),
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
                prefixIcon: Icon(Icons.pin_drop_outlined),
                border: OutlineInputBorder(),
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
        ),
        isActive: _currentStep == 1,
      ),
      Step(
        title: const Text('Business Info'),
        content: Column(
          children: [
            TextFormField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                labelText: 'Business Name',
                prefixIcon: Icon(Icons.business_outlined),
                border: OutlineInputBorder(),
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
                prefixIcon: Icon(Icons.description_outlined),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
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
              children:
                  [
                    'Wedding Hall',
                    'Banquet Hall',
                    'Conference Center',
                    'Farmhouse',
                    'Resort',
                    'Tent House',
                  ].map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: category == 'Wedding Hall', // Default selection
                      onSelected: (selected) {
                        // Logic to select only one chip
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Theme.of(
                        context,
                      ).primaryColor.withAlpha(51), // equivalent to opacity 0.2
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:
                              category == 'Wedding Hall'
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
        ),
        isActive: _currentStep == 2,
      ),
    ];
  }
}
