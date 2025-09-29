import 'package:flutter/cupertino.dart';

class HSpacing extends StatelessWidget {
  const HSpacing(this.space, {super.key});

  final double space;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: space);
  }
}

class WSpacing extends StatelessWidget {
  const WSpacing(this.space, {super.key});

  final double space;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: space);
  }
}
