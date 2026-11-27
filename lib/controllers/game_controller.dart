import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:tic_tac_toe/models/tic_tac_toe_game.dart';

class GameController extends ChangeNotifier {
  GameController({
    required String playerSide,
    required this.isAiMode,
  }) : playerMark = TicTacToeGame.normalizeSide(playerSide) {
    _nextStartingMark = Random().nextBool()
        ? TicTacToeGame.x
        : TicTacToeGame.o;
    _startRound();
  }

  final bool isAiMode;
  final String playerMark;
  final TicTacToeGame game = TicTacToeGame();

  String _nextStartingMark = TicTacToeGame.x;
  int _roundToken = 0;
  int playerScore = 0;
  int opponentScore = 0;
  bool isAiThinking = false;
  bool _isDisposed = false;

  String get playerOneName {
    if (isAiMode) return 'Player';
    return playerMark == TicTacToeGame.x ? 'Player 1' : 'Player 2';
  }

  String get playerTwoName {
    if (isAiMode) return 'AI';
    return playerMark == TicTacToeGame.x ? 'Player 2' : 'Player 1';
  }

  String nameForMark(String mark) {
    if (isAiMode) return mark == playerMark ? 'Player' : 'AI';
    return mark == playerMark ? 'Player 1' : 'Player 2';
  }

  bool get isPlayerTurn => game.currentPlayer == playerMark;

  String get turnMessage {
    if (game.isOver) return game.winner;
    if (isAiThinking) return 'AI is thinking...';
    return "${nameForMark(game.currentPlayer)}'s turn";
  }

  void _startRound() {
    _roundToken++;
    isAiThinking = false;
    game.reset(startingPlayer: _nextStartingMark);

    if (isAiMode && !isPlayerTurn) {
      game.playAiMove(
        aiMark: game.currentPlayer,
        playerMark: playerMark,
      );
    }
  }

  Future<void> playAt(int index) async {
    if (game.isOver ||
        isAiThinking ||
        (isAiMode && !isPlayerTurn)) {
      return;
    }

    if (!game.play(index)) return;

    final aiShouldMove = !game.isOver && isAiMode && !isPlayerTurn;
    isAiThinking = aiShouldMove;
    _updateScore();
    notifyListeners();

    if (!aiShouldMove) return;

    final roundToken = _roundToken;
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (_isDisposed || roundToken != _roundToken) return;

    if (!game.isOver && !isPlayerTurn) {
      game.playAiMove(
        aiMark: game.currentPlayer,
        playerMark: playerMark,
      );
      _updateScore();
    }
    isAiThinking = false;
    notifyListeners();
  }

  void resetRound() {
    _nextStartingMark = TicTacToeGame.other(_nextStartingMark);
    _startRound();
    notifyListeners();
  }

  void _updateScore() {
    final winner = game.winnerMark;
    if (winner == null) return;

    if (winner == playerMark) {
      playerScore++;
    } else {
      opponentScore++;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _roundToken++;
    super.dispose();
  }
}
