import 'package:material_ui/material_ui.dart';
import 'package:tic_tac_toe/screens/chose_side_screen.dart';
import 'package:tic_tac_toe/theme/app_theme.dart';
import 'package:tic_tac_toe/widgets/app_button.dart';
import 'package:tic_tac_toe/widgets/app_image.dart';
import 'package:tic_tac_toe/widgets/app_text.dart';
import 'package:tic_tac_toe/widgets/entrance_animation.dart';

class PlayModeScreen extends StatefulWidget {
  const PlayModeScreen({super.key});

  @override
  State<PlayModeScreen> createState() => _PlayModeScreenState();
}

class _PlayModeScreenState extends State<PlayModeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _aiButtonAnimation;
  late final Animation<double> _friendButtonAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _aiButtonAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
    );
    _friendButtonAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1, curve: Curves.easeOutCubic),
    );
    _controller.forward();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppImage(assetPath: 'assets/both.png', width: 150),
            const SizedBox(height: 35),
            const AppText(
              'Chose your play mode',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 35),
            EntranceAnimation(
              animation: _aiButtonAnimation,
              child: AppButton(
                label: 'With AI',
                onPressed: () => _openSideSelection(context, isAi: true),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            EntranceAnimation(
              animation: _friendButtonAnimation,
              child: AppButton(
                label: 'With Friend',
                onPressed: () => _openSideSelection(context, isAi: false),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSideSelection(BuildContext context, {required bool isAi}) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChoseSideScreen(isAi: isAi),
      ),
    );
  }
}
