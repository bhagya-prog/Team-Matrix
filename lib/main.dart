import 'package:flutter/material.dart';

// CORE
import 'core/theme.dart';
import 'core/colors.dart';

// AUTH
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/auth_gate.dart';

// MAIN SCREENS
import 'screens/home/home_screen.dart';
import 'screens/assistant/assistant_screen.dart';
import 'screens/learn/learn_screen.dart';
import 'screens/diary/diary_screen.dart';
import 'screens/community/community_screen.dart';

void main() {
  runApp(const GrameenFinanceApp());
}

class GrameenFinanceApp extends StatelessWidget {
  const GrameenFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/gate',

      routes: {
        '/gate': (context) => const AuthGate(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}

///
/// 🔻 MAIN APP WITH BOTTOM NAVIGATION (NO MIC HERE)
///
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    AssistantScreen(),
    LearnScreen(),
    DiaryScreen(),
    CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy), label: "Assistant"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: "Learn"),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: "Diary"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "Community"),
        ],
      ),
    );
  }
}
