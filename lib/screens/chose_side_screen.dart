import 'package:material_ui/material_ui.dart';
import 'package:tic_tac_toe/models/tic_tac_toe_game.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/theme/app_theme.dart';
import 'package:tic_tac_toe/widgets/app_button.dart';
import 'package:tic_tac_toe/widgets/app_text.dart';
import 'package:tic_tac_toe/widgets/entrance_animation.dart';
import 'package:tic_tac_toe/widgets/side_option.dart';

class ChoseSideScreen extends StatefulWidget {
  const ChoseSideScreen({super.key, required this.isAi});

  final bool isAi;

  @override
  State<ChoseSideScreen> createState() => _ChoseSideScreenState();
}

class _ChoseSideScreenState extends State<ChoseSideScreen>
    with SingleTickerProviderStateMixin {
  String _selectedSide = TicTacToeGame.x;
  late final AnimationController _controller;
  late final Animation<double> _titleAnimation;
  late final Animation<double> _xAnimation;
  late final Animation<double> _oAnimation;
  late final Animation<double> _continueAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _titleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.05, 0.4, curve: Curves.easeOutCubic),
    );
    _xAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
    );
    _oAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
    );
    _continueAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1, curve: Curves.easeOutCubic),
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
            EntranceAnimation(
              animation: _titleAnimation,
              child: const AppText(
                'Pick your side',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            RadioGroup<String>(
              groupValue: _selectedSide,
              onChanged: (value) {
                if (value != null) _selectSide(value);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EntranceAnimation(
                    animation: _xAnimation,
                    child: const SideOption(mark: TicTacToeGame.x),
                  ),
                  const SizedBox(width: 10),
                  EntranceAnimation(
                    animation: _oAnimation,
                    child: const SideOption(mark: TicTacToeGame.o),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            EntranceAnimation(
              animation: _continueAnimation,
              child: AppButton(
                label: 'Continue',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => GameScreen(
                        playerSide: _selectedSide,
                        isAi: widget.isAi,
                      ),
                    ),
                  );
                },
                minimumSize: const Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectSide(String side) {
    setState(() => _selectedSide = side);
  }
}
