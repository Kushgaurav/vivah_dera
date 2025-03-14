import 'package:flutter/material.dart';
import 'package:vivah_dera/screens/onboarding/login_screen.dart';
import 'package:vivah_dera/screens/onboarding/signup_screen.dart';
import 'package:vivah_dera/screens/onboarding/splash_screen.dart';
import 'package:vivah_dera/screens/onboarding/verification_screen.dart';
import 'package:vivah_dera/screens/onboarding/welcome_screen.dart';
import 'package:vivah_dera/screens/owner/owner_dashboard_screen.dart';
import 'package:vivah_dera/screens/renter/booking_confirmation_screen.dart';
import 'package:vivah_dera/screens/renter/booking_screen.dart';
import 'package:vivah_dera/screens/renter/listing_detail_screen.dart';
import 'package:vivah_dera/screens/renter/renter_home_screen.dart';
import 'package:vivah_dera/screens/shared/notifications_screen.dart';
import 'package:vivah_dera/services/notification_service.dart';
import 'package:vivah_dera/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivah Dera',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/owner_dashboard': (context) => const OwnerDashboardScreen(),
        '/renter_home': (context) => const RenterHomeScreen(),
        '/listing_detail': (context) => const ListingDetailScreen(),
        '/booking': (context) => const BookingScreen(),
        '/booking_confirmation': (context) => const BookingConfirmationScreen(
              bookingData: {},
            ),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}
