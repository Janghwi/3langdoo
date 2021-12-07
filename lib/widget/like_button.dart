import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class LikeButtonWidget extends StatefulWidget {
  const LikeButtonWidget({Key? key}) : super(key: key);

  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  bool isLiked = false;
  bool hasBackground = false;
  int likeCount = 17;
  // final key2 = GlobalKey<LikeButtonState>();

  @override
  Widget build(BuildContext context) {
    const double size = 40;
    final animationDuration = Duration(milliseconds: 1500);

    return LikeButton(
      // key: key2,
      padding: EdgeInsets.all(12),
      size: size,
      isLiked: isLiked,
      likeCount: likeCount,
      circleColor: CircleColor(
        start: Colors.blue,
        end: Colors.blue,
      ),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Colors.green,
        dotSecondaryColor: Colors.greenAccent,
      ),
      likeBuilder: (isLiked) {
        final color = isLiked ? Colors.red : Colors.grey;

        return Icon(Icons.favorite, color: color, size: size);
      },
      animationDuration: animationDuration,
      likeCountPadding: EdgeInsets.only(left: 12),
      countBuilder: (count, isLiked, text) {
        final color = isLiked ? Colors.black : Colors.grey;

        return Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );
      },
      onTap: (isLiked) async {
        this.isLiked = !isLiked;
        likeCount += this.isLiked ? 1 : -1;

        Future.delayed(animationDuration)
            .then((_) => setState(() => hasBackground = !isLiked));

        // server request

        return !isLiked;
      },
    );
  }
}
