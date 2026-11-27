import 'package:material_ui/material_ui.dart';
import 'package:tic_tac_toe/screens/play_mode_screen.dart';
import 'package:tic_tac_toe/theme/app_theme.dart';
import 'package:tic_tac_toe/widgets/app_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const List<String> _marks = [
    'X', 'O', 'X',
    'O', 'X', 'O',
    'X', 'O', 'X',
  ];

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..forward();

    Future<void>.delayed(const Duration(milliseconds: 4200), _openPlayModes);
  }

  void _openPlayModes() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement<void, void>(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PlayModeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final zoom = Tween<double>(begin: 0.88, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: zoom, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 216,
              height: 216,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _marks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  final begin = index * 0.07;
                  final markAnimation = CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      begin,
                      (begin + 0.42).clamp(0.0, 1.0),
                      curve: Curves.easeOutCubic,
                    ),
                  );
                  final isX = _marks[index] == 'X';

                  return AnimatedBuilder(
                    animation: markAnimation,
                    builder: (context, child) => Opacity(
                      opacity: markAnimation.value,
                      child: Transform.scale(
                        scale: 0.65 + markAnimation.value * 0.35,
                        child: child,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AppText(
                          _marks[index],
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: isX ? Colors.blue : Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const AppText(
              'Tic Tac Toe',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xff202124),
              ),
            ),
            const SizedBox(height: 8),
            const AppText(
              'Get ready to play',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 150,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => LinearProgressIndicator(
                  value: _controller.value,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(4),
                  backgroundColor: Colors.blue.withValues(alpha: 0.15),
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
