import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/lab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // قفل الشاشة بالطول عشان المعمل يبان أحسن
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // شاشة كاملة
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MagicLabApp());
}

class MagicLabApp extends StatelessWidget {
  const MagicLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "المعمل السحري",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0A14),
        fontFamily: 'monospace', // ممكن تغيرها لخط تاني لو حابب
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFFFFD54A),
        ),
      ),
      home: const LabScreen(),
    );
  }
}