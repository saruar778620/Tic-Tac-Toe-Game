import 'dart:math';

/// Reusable rules and state for a standard 3x3 tic-tac-toe game.
class TicTacToeGame {
  static const String x = 'X';
  static const String o = 'O';
  static const String draw = 'Draw!';

  static const List<List<int>> winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  List<String> board = List.filled(9, '');
  String currentPlayer = x;
  String winner = '';
  String? winnerMark;
  List<int>? winningLine;

  bool get isOver => winner.isNotEmpty;
  bool get isDraw => winner == draw;

  /// Places the current player's mark. Returns false for invalid/finished moves.
  bool play(int index) {
    if (isOver || index < 0 || index >= board.length || board[index].isNotEmpty) {
      return false;
    }

    board[index] = currentPlayer;
    final completedLine = findWinningLine(currentPlayer);
    if (completedLine != null) {
      winningLine = completedLine;
      winnerMark = currentPlayer;
      winner = '$currentPlayer Wins!';
    } else if (!board.contains('')) {
      winner = draw;
    } else {
      currentPlayer = other(currentPlayer);
    }
    return true;
  }

  /// Plays one move using the requested priority-based AI strategy.
  bool playAiMove({required String aiMark, required String playerMark}) {
    if (isOver || currentPlayer != aiMark) return false;

    final move = _findWinningMove(aiMark) ??
        _findWinningMove(playerMark) ??
        _preferredOpenCell() ??
        _firstOpenCell();

    return move == null ? false : play(move);
  }

  void reset({String startingPlayer = x}) {
    board = List.filled(9, '');
    currentPlayer = startingPlayer == o ? o : x;
    winner = '';
    winnerMark = null;
    winningLine = null;
  }

  static String other(String mark) => mark == x ? o : x;

  static String normalizeSide(String side) {
    final normalized = side.trim().toUpperCase();
    return normalized == o || normalized == '0' ? o : x;
  }

  bool checkWinner(String player) => findWinningLine(player) != null;

  List<int>? findWinningLine(String player) {
    for (final line in winningLines) {
      if (line.every((index) => board[index] == player)) {
        return line;
      }
    }
    return null;
  }

  int? _findWinningMove(String mark) {
    for (var index = 0; index < board.length; index++) {
      if (board[index].isNotEmpty) continue;

      board[index] = mark;
      final wins = checkWinner(mark);
      board[index] = '';
      if (wins) return index;
    }
    return null;
  }

  int? _preferredOpenCell() {
    if (board[4].isEmpty) return 4;

    final openCorners = [0, 2, 6, 8]
        .where((index) => board[index].isEmpty)
        .toList();
    if (openCorners.isEmpty) return null;
    return openCorners[Random().nextInt(openCorners.length)];
  }

  int? _firstOpenCell() {
    final emptyIndices = [
      for (var index = 0; index < board.length; index++)
        if (board[index].isEmpty) index,
    ];
    if (emptyIndices.isEmpty) return null;
    return emptyIndices[Random().nextInt(emptyIndices.length)];
  }
}
