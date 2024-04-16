import 'package:flutter/material.dart';
import 'package:y_videos/screens/fragments/search/search_results/search_results.dart';
import 'package:y_videos/screens/login/login.dart';
import 'package:y_videos/screens/main_screens.dart';
import 'package:y_videos/screens/profile/edit_profile/edit_id_profile/edit_id_profile.dart';
import 'package:y_videos/screens/profile/edit_profile/edit_name_profile/edit_name_profile.dart';
import 'package:y_videos/screens/profile/edit_profile/edit_password_profile/edit_password_profile.dart';
import 'package:y_videos/screens/profile/edit_profile/edit_profile.dart';
import 'package:y_videos/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:y_videos/servieces/color_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YVideos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'NotoSants',
        primaryColor: Colors.white, // Màu chủ đạo
        colorScheme: ColorScheme.fromSeed(seedColor: ColorServices.primaryColor),
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
        '/edit-profile': (context) => EditProfile(),
        '/edit-name-profile': (context) => EditNameProfile(),
        '/edit-id-profile': (context) => EditIDProfile(),
        '/edit-password-profile': (context) => EditPasswordProfile(),

      },
    );
  }
}
