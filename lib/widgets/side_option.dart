import 'package:material_ui/material_ui.dart';
import 'package:tic_tac_toe/models/tic_tac_toe_game.dart';
import 'package:tic_tac_toe/widgets/game_mark_image.dart';

class SideOption extends StatelessWidget {
  const SideOption({super.key, required this.mark});

  final String mark;

  @override
  Widget build(BuildContext context) {
    final isX = mark == TicTacToeGame.x;

    return Column(
      children: [
        GameMarkImage(mark: mark, width: 100, fit: BoxFit.cover),
        Transform.scale(
          scale: 1.5,
          child: Radio<String>(
            value: mark,
            activeColor: isX ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
