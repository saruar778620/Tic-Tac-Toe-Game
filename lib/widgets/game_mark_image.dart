import 'package:flutter/widgets.dart';
import 'package:tic_tac_toe/models/tic_tac_toe_game.dart';
import 'package:tic_tac_toe/widgets/app_image.dart';

class GameMarkImage extends StatelessWidget {
  const GameMarkImage({
    super.key,
    required this.mark,
    this.width = 80,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String mark;
  final double width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final asset = mark.toUpperCase() == TicTacToeGame.x
        ? 'assets/cros.png'
        : 'assets/circle.png';

    return AppImage(assetPath: asset, width: width, height: height, fit: fit);
  }
}
