import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/view/Theme/color_theme.dart';
import 'package:poultry_pro/view/Theme/text_theme.dart';
import 'view/screens/splash_screen.dart';
import 'view/screens/welcome_screen.dart';
import 'view/screens/auth/signup/biometrics.dart';
import 'view/screens/auth/signup/details_screen.dart';
import 'view/screens/auth/signup/password_setup.dart';
import 'view/screens/auth/signup/pin_setup.dart';
import 'view/screens/auth/signup/verification_screen.dart';
import 'view/screens/auth/login/password_login.dart';
import 'view/screens/auth/login/pin_login.dart';
import 'view/screens/mainScreen/home_screen.dart';
import 'view/screens/mainScreen/flocks_screen.dart';
import 'view/screens/mainScreen/finance_screen.dart';
import 'view/screens/mainScreen/production_screen.dart';
import 'view/screens/mainScreen/settings_screen.dart';
import 'view/screens/mainScreen/main_screen.dart';

void main() {
  runApp(ProviderScope(child: PoultryPro()));
}

class PoultryPro extends StatelessWidget {
  const PoultryPro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Poultry Pro",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: lightMode,
        scaffoldBackgroundColor: Color(0xFFF7F8FA),
        textTheme: textTheme,
      ),
      darkTheme: ThemeData(
        colorScheme: darkMode,
        scaffoldBackgroundColor: Color(0xFF0D1117),
        textTheme: textTheme,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/flocks',
      routes: {
        '/': (context) => SplashScreen(),
        '/wel': (context) => WelcomeScreen(),
        '/sudetails': (context) => DetailsScreen(),
        '/ver': (context) => VerificationScreen(),
        '/piSetup': (context) => PinSetup(),
        '/paSetup': (context) => PasswordSetup(),
        '/bio': (context) => Biometrics(),
        '/piLogin': (context) => PinLogin(),
        '/paLogin': (context) => PasswordLogin(),
        '/home': (context) => Home(),
        '/flocks': (context) => Flocks(),
        '/finance': (context) => Finance(),
        '/production': (context) => Production(),
        '/settings': (context) => Settings(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
