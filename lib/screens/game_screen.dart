import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/tic_tac_toe_game.dart';

class GameScreen extends StatefulWidget {
  final String playerSide;
  final bool isAi;

  const GameScreen({super.key, required this.playerSide, required this.isAi});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final String playerMark;
  late final TicTacToeGame game;
  late String nextStartingMark;
  int playerScore = 0;
  int aiScore = 0;
  int _roundToken = 0;
  bool _isAiThinking = false;

  String get playerOneName {
    if (widget.isAi) return 'Player';
    return playerMark == TicTacToeGame.x ? 'Player 1' : 'Player 2';
  }

  String get playerTwoName {
    if (widget.isAi) return 'AI';
    return playerMark == TicTacToeGame.x ? 'Player 2' : 'Player 1';
  }

  String _nameForMark(String mark) {
    if (widget.isAi) {
      return mark == playerMark ? 'Player' : 'AI';
    }
    return mark == playerMark ? 'Player 1' : 'Player 2';
  }

  @override
  void initState() {
    super.initState();
    playerMark = TicTacToeGame.normalizeSide(widget.playerSide);
    nextStartingMark = Random().nextBool()
        ? TicTacToeGame.x
        : TicTacToeGame.o;
    game = TicTacToeGame();
    _startRound();
  }

  void _startRound() {
    _roundToken++;
    _isAiThinking = false;
    game.reset(startingPlayer: nextStartingMark);
    if (widget.isAi && game.currentPlayer != playerMark) {
      game.playAiMove(
        aiMark: game.currentPlayer,
        playerMark: playerMark,
      );
    }
  }

  Future<void> makeMove(int index) async {
    if (game.isOver ||
        _isAiThinking ||
        (widget.isAi && game.currentPlayer != playerMark)) {
      return;
    }

    var aiShouldMove = false;
    setState(() {
      if (!game.play(index)) return;

      aiShouldMove =
          !game.isOver && widget.isAi && game.currentPlayer != playerMark;
      _isAiThinking = aiShouldMove;
      _updateScore();
    });

    if (!aiShouldMove) return;

    final roundToken = _roundToken;
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted || roundToken != _roundToken) return;

    setState(() {
      if (!game.isOver && game.currentPlayer != playerMark) {
        game.playAiMove(
          aiMark: game.currentPlayer,
          playerMark: playerMark,
        );
        _updateScore();
      }
      _isAiThinking = false;
    });
  }

  void _updateScore() {
    final winnerMark = game.winnerMark;
    if (winnerMark == null) return;

    if (winnerMark == playerMark) {
      playerScore++;
    } else {
      aiScore++;
    }
  }

  void resetBoard() {
    setState(() {
      nextStartingMark = TicTacToeGame.other(nextStartingMark);
      _startRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  playerOneName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 30,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    '$playerScore - $aiScore',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  playerTwoName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          game.isOver
              ? Text(
                  game.winner,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      game.currentPlayer == TicTacToeGame.x
                          ? 'assets/cros.png'
                          : 'assets/circle.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isAiThinking
                          ? 'AI is thinking...'
                          : "${_nameForMark(game.currentPlayer)}'s turn",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          Card(
            color: Colors.white,
            elevation: 5,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => makeMove(index),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index < 6
                                  ? const BorderSide(
                                      width: 2,
                                      color: Colors.green,
                                    )
                                  : BorderSide.none,
                              right: index % 3 != 2
                                  ? const BorderSide(
                                      width: 2,
                                      color: Colors.red,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Center(
                            child: game.board[index] == TicTacToeGame.x
                                ? Image.asset('assets/cros.png', width: 80)
                                : game.board[index] == TicTacToeGame.o
                                    ? Image.asset(
                                        'assets/circle.png',
                                        width: 80,
                                      )
                                    : null,
                          ),
                        ),
                      );
                    },
                  ),
                  if (game.winningLine != null)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: WinningLinePainter(game.winningLine!),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50),
              backgroundColor: Colors.blue,
              elevation: 10,
              shadowColor: Colors.blueGrey,
            ),
            onPressed: resetBoard,
            child: const Text(
              'Reset Game',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class WinningLinePainter extends CustomPainter {
  const WinningLinePainter(this.winningLine);

  final List<int> winningLine;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / 3;
    final cellHeight = size.height / 3;

    Offset centerOf(int index) {
      final row = index ~/ 3;
      final column = index % 3;
      return Offset(
        (column + 0.5) * cellWidth,
        (row + 0.5) * cellHeight,
      );
    }

    final start = centerOf(winningLine.first);
    final end = centerOf(winningLine.last);
    final outlinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    final linePaint = Paint()
      ..color = Colors.amber.shade700
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, outlinePaint);
    canvas.drawLine(start, end, linePaint);
  }

  @override
  bool shouldRepaint(covariant WinningLinePainter oldDelegate) {
    return oldDelegate.winningLine != winningLine;
  }
}
