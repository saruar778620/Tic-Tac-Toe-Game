import 'package:material_ui/material_ui.dart';
import 'package:tic_tac_toe/controllers/game_controller.dart';
import 'package:tic_tac_toe/widgets/winning_line.dart';
import 'package:tic_tac_toe/widgets/game_mark_image.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final game = controller.game;

    return Card(
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: game.board.length,
              itemBuilder: (context, index) {
                final mark = game.board[index];
                return GestureDetector(
                  onTap: () => controller.playAt(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: index < 6
                            ? const BorderSide(width: 2, color: Colors.green)
                            : BorderSide.none,
                        right: index % 3 != 2
                            ? const BorderSide(width: 2, color: Colors.red)
                            : BorderSide.none,
                      ),
                    ),
                    child: mark.isEmpty
                        ? null
                        : Center(child: GameMarkImage(mark: mark)),
                  ),
                );
              },
            ),
            if (game.winningLine != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedWinningLine(
                    key: ValueKey(game.winningLine!.join(',')),
                    winningLine: game.winningLine!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
