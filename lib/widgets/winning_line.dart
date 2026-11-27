import 'package:material_ui/material_ui.dart';

class AnimatedWinningLine extends StatefulWidget {
  const AnimatedWinningLine({super.key, required this.winningLine});

  final List<int> winningLine;

  @override
  State<AnimatedWinningLine> createState() => _AnimatedWinningLineState();
}

class _AnimatedWinningLineState extends State<AnimatedWinningLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
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
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) => CustomPaint(
        painter: WinningLinePainter(widget.winningLine, _progress.value),
      ),
    );
  }
}

class WinningLinePainter extends CustomPainter {
  const WinningLinePainter(this.winningLine, this.progress);

  final List<int> winningLine;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (winningLine.isEmpty || size.isEmpty) return;

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
    final end = Offset.lerp(start, centerOf(winningLine.last), progress)!;
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
    return oldDelegate.progress != progress ||
        oldDelegate.winningLine != winningLine;
  }
}
