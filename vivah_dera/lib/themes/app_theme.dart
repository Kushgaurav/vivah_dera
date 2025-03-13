import 'package:flutter/material.dart';

/// AppTheme defines the visual styling for the Vivah Dera application
/// following the design system from the UI/UX design guide.
class AppTheme {
  // Color System from UI/UX Design Guide
  /// Primary brand color - Blue: Conveys trust and stability
  static const Color primaryColor = Color(0xFF3A66DB);

  /// Secondary brand color - Teal: Fresh and modern accent
  static const Color secondaryColor = Color(0xFF00C6AE);

  /// Tertiary brand color - Coral: Energetic call-to-action
  static const Color tertiaryColor = Color(0xFFFF8547);

  // Neutrals
  /// Dark neutral - Used for text and important elements
  static const Color darkColor = Color(0xFF252D3C);

  /// Mid neutral - Used for secondary text, borders, icons
  static const Color midColor = Color(0xFF7A869A);

  /// Light neutral - Used for backgrounds, cards in light mode
  static const Color lightColor = Color(0xFFF4F7FC);

  // Semantic Colors
  /// Success color - Used for confirmations and approvals
  static const Color successColor = Color(0xFF32D583);

  /// Warning color - Used for alerts and pending status
  static const Color warningColor = Color(0xFFFFBE0B);

  /// Error color - Used for error states and critical information
  static const Color errorColor = Color(0xFFFF5252);

  // Typography Styles - Based on 8px grid system
  /// Display text - For hero sections and major headings (34px)
  static const displayTextStyle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  /// Heading 1 - For screen titles and major section headers (28px)
  static const heading1TextStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  /// Heading 2 - For section headers and card titles (22px)
  static const heading2TextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  /// Heading 3 - For subsection titles and emphasized content (18px)
  static const heading3TextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    height: 1.2,
  );

  /// Body 1 - Primary text style for content and descriptions (16px)
  static const body1TextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  /// Body 2 - Secondary text style for supporting content (14px)
  static const body2TextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  /// Caption - Used for supplementary information, timestamps (12px)
  static const captionTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  /// Button text - Optimized for buttons and interactive elements (16px)
  static const buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.25,
  );

  /// Light Theme Configuration
  /// Follows Material 3 guidelines with our custom color system
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // Color scheme defines the core color palette for the light theme
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      tertiary: tertiaryColor,
      onTertiary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: lightColor,
      onBackground: darkColor,
      surface: Colors.white,
      onSurface: darkColor,
    ),
    scaffoldBackgroundColor: lightColor,
    // AppBar styling for light mode - white background with dark content
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: darkColor,
      elevation: 0,
      centerTitle: true,
    ),
    // Button themes maintain consistent padding, shapes and elevation
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    // Form input styling with consistent border radius and states
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: midColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: midColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    ),
    // Card styling with consistent elevation and rounded corners
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(8),
    ),
    // Bottom navigation bar styling for light mode
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: midColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  /// Dark Theme Configuration
  /// Optimized for low-light conditions with proper contrast
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // Dark mode color scheme with appropriate surface colors
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      tertiary: tertiaryColor,
      onTertiary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: Color(0xFF121212),
      onBackground: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Color(0xFF121212), // Material dark background
    // Dark mode AppBar with subtle contrast from background
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    // Button themes consistent with light theme but adapted for dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    // Dark mode input fields with higher contrast backgrounds
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: midColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: midColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    ),
    // Cards with darker surface for better content contrast
    cardTheme: CardThemeData(
      color: Color(0xFF2C2C2C),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(8),
    ),
    // Dialog styling for dark mode with rounded corners
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF2C2C2C),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    // Chip styling for filters, selections, and tags
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF3D3D3D), // Slightly lighter than surface
      disabledColor: Color(0xFF707070), // Medium gray for disabled state
      selectedColor: primaryColor.withOpacity(0.2), // Semi-transparent primary
      secondarySelectedColor: secondaryColor.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      labelStyle: body2TextStyle.copyWith(color: Colors.white),
      secondaryLabelStyle: body2TextStyle.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ), // Pill shape
    ),
    // Tab bar styling for categorized content navigation
    tabBarTheme: TabBarThemeData(
      labelColor: primaryColor, // Selected tab uses primary color
      unselectedLabelColor: Color(0xFFBDBDBD), // Light gray for unselected
      indicatorColor: primaryColor, // Indicator matches selected label
      indicatorSize: TabBarIndicatorSize.tab, // Full-width indicator
      labelStyle: buttonTextStyle, // Bold for selected tabs
      unselectedLabelStyle: buttonTextStyle.copyWith(
        fontWeight: FontWeight.normal, // Regular weight for unselected
      ),
    ),
    // Bottom navigation consistent with overall dark theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E), // Surface color
      selectedItemColor: primaryColor, // Primary color for selected item
      unselectedItemColor: Color(0xFFBDBDBD), // Light gray for unselected
      type: BottomNavigationBarType.fixed, // Fixed navigation style
      elevation: 8, // Subtle shadow for depth
    ),
  );
}
