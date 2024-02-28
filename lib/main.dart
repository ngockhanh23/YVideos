import 'package:flutter/material.dart';
import 'package:y_videos/screens/fragments/search/search_results/search_results.dart';
import 'package:y_videos/screens/login/login.dart';
import 'package:y_videos/screens/main_screens.dart';
import 'package:y_videos/screens/profile/edit_profile/edit_id_profile/edit_id_profile.dart';
import 'package:y_videos/screens/profile/edit_profile/edit_name_profile/edit_name_profile.dart';
import 'package:y_videos/screens/profile/edit_profile/edit_profile.dart';
import 'package:y_videos/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.white, // Màu chủ đạo của ứng dụng
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffff2100)),
        scaffoldBackgroundColor: Colors.white, // Màu nền cho Scaffold
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black), // Màu chữ mặc định
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => Login(),
        '/main-screens': (context) => MainScreens(),
        '/search-results': (context) => SearchResults(),
        '/edit-profile': (context) => EditProfile(),
        '/edit-name-profile': (context) => EditNameProfile(),
        '/edit-id-profile': (context) => EditIDProfile(),
      },
    );
  }
}
