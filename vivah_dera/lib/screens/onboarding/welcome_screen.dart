import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(),
              // App Logo
              Container(
                width: isSmallScreen ? 120 : 160,
                height: isSmallScreen ? 120 : 160,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.home_work_rounded,
                  size: isSmallScreen ? 60 : 80,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // Welcome Text
              Text(
                'Welcome to Vivah Dera',
                style: AppTheme.heading1TextStyle.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 48,
                ),
                child: Text(
                  'Your one-stop solution for finding and managing tent houses and event spaces',
                  style: AppTheme.body1TextStyle.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),

              // Buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56),
                ),
                child: Text('Log In', style: AppTheme.buttonTextStyle),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(color: AppTheme.primaryColor),
                  minimumSize: Size(double.infinity, 56),
                ),
                child: Text(
                  'Sign Up',
                  style: AppTheme.buttonTextStyle.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Terms and Conditions
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                style: AppTheme.captionTextStyle.copyWith(
                  color: AppTheme.midColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 24 : 48),
            ],
          ),
        ),
      ),
    );
  }
}
