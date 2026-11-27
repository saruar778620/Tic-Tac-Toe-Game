import 'package:material_ui/material_ui.dart';
import 'package:tic_tac_toe/controllers/game_controller.dart';
import 'package:tic_tac_toe/models/tic_tac_toe_game.dart';
import 'package:tic_tac_toe/theme/app_theme.dart';
import 'package:tic_tac_toe/widgets/app_button.dart';
import 'package:tic_tac_toe/widgets/app_text.dart';
import 'package:tic_tac_toe/widgets/game_board.dart';
import 'package:tic_tac_toe/widgets/game_mark_image.dart';
import 'package:tic_tac_toe/widgets/game_score_header.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.playerSide,
    required this.isAi,
  });

  final String playerSide;
  final bool isAi;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameController(
      playerSide: widget.playerSide,
      isAiMode: widget.isAi,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final game = _controller.game;

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GameScoreHeader(
                firstPlayer: _controller.playerOneName,
                secondPlayer: _controller.playerTwoName,
                firstScore: _controller.playerScore,
                secondScore: _controller.opponentScore,
              ),
              const SizedBox(height: 20),
              _buildTurnStatus(game),
              const SizedBox(height: 20),
              GameBoard(controller: _controller),
              const SizedBox(height: 20),
              AppButton(
                label: 'Reset Game',
                onPressed: _controller.resetRound,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 50),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTurnStatus(TicTacToeGame game) {
    if (game.isOver) {
      return AppText(
        game.winner,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
    }

    final mark = game.currentPlayer;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GameMarkImage(mark: mark, width: 32, height: 32),
        const SizedBox(width: 10),
        AppText(
          _controller.turnMessage,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
