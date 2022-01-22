import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/layout/simple_puzzle_layout_delegate.dart';

void main() => runApp(const LogoApp());

// #docregion AnimatedLogo
class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Container(
        alignment: Alignment(-0.5 + animation.value, -0.5 + animation.value),
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 100, //animation.value,
        width: 100, //animation.value,
        child: _showDash(context),
        // child: const FlutterLogo(),
      ),
    );
  }

  Widget _showDash(BuildContext context) {
    return SizedBox(
        width: 70,
        height: 70,
        child: Image.asset(
          '../assets/images/simple_dash_small.png',
          fit: BoxFit.cover,
        ),
      );
  }

}
// #enddocregion AnimatedLogo

class LogoApp extends StatefulWidget {
  const LogoApp({Key? key}) : super(key: key);

  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
