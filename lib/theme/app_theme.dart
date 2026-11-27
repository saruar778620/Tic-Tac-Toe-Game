import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xfff6f6f6);

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.audiowideTextTheme(),
      );
}
