import 'package:material_ui/material_ui.dart';
import 'package:tic_tac_toe/widgets/app_text.dart';

class GameScoreHeader extends StatelessWidget {
  const GameScoreHeader({
    super.key,
    required this.firstPlayer,
    required this.secondPlayer,
    required this.firstScore,
    required this.secondScore,
  });

  final String firstPlayer;
  final String secondPlayer;
  final int firstScore;
  final int secondScore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            firstPlayer,
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
            child: AppText(
              '$firstScore - $secondScore',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          AppText(
            secondPlayer,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
