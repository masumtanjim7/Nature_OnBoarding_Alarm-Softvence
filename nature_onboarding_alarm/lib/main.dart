import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helpers/notification_helper.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/alarm/alarm_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AlarmController())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Onboarding Alarm App',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily:
              'SF Pro Display', // If not available, Flutter will fallback safely
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
