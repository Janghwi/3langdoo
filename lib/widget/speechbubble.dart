import 'package:flutter/material.dart';

// speechwithbubble
class SpeechBubbleWidget extends StatelessWidget {
  final Widget child;

  const SpeechBubbleWidget({
    required this.child,
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: child,
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(right: 52),
                child: ClipPath(
                  clipper: SpeechBubbleClipper(),
                  child: Container(color: Colors.white, width: 80, height: 40),
                ),
              ),
            ),
          ],
        ),
      );
}

class SpeechBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    /// move to middle
    path.moveTo(size.width / 2, 0);

    /// Line to end
    path.lineTo(size.width, 0);

    /// First curve down
    path.quadraticBezierTo(size.width / 2, size.height - 2, 0, size.height);

    /// Second curve up
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width / 2, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
