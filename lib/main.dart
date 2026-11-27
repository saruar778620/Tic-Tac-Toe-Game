import 'package:material_ui/material_ui.dart';
import 'package:tic_tac_toe/screens/splash_screen.dart';
import 'package:tic_tac_toe/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
