import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';

class ChoseSideScreen extends StatefulWidget {
  const ChoseSideScreen({super.key, required this.isAi});

  final bool isAi;

  @override
  State<ChoseSideScreen> createState() => _ChoseSideScreenState();
}

class _ChoseSideScreenState extends State<ChoseSideScreen>
    with SingleTickerProviderStateMixin {
  String seletesSide = 'X';
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
      curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animateIn(Animation<double> animation, Widget child) {
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(animation);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: slide, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _animateIn(
              _titleAnimation,
              const Text(
                'Pick your side',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _animateIn(
                  _xAnimation,
                  Column(
                    children: [
                      Image.asset(
                        'assets/cros.png',
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Radio(
                          value: 'X',
                          groupValue: seletesSide,
                          activeColor: Colors.green,
                          onChanged: (String? value) {
                            if (value == null) return;
                            setState(() {
                              seletesSide = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _animateIn(
                  _oAnimation,
                  Column(
                    children: [
                      Image.asset(
                        'assets/circle.png',
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Radio(
                          value: 'O',
                          groupValue: seletesSide,
                          activeColor: Colors.red,
                          onChanged: (String? value) {
                            if (value == null) return;
                            setState(() {
                              seletesSide = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _animateIn(
              _continueAnimation,
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(
                        playerSide: seletesSide,
                        isAi: widget.isAi,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
