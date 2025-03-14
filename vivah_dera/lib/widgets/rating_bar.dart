import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showText;
  final TextStyle? textStyle;

  const RatingBar({
    super.key,
    required this.rating,
    this.size = 24,
    this.color,
    this.showText = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? Colors.amber;
    final int fullStars = rating.floor();
    final bool hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            if (index < fullStars) {
              return Icon(Icons.star, size: size, color: starColor);
            } else if (index == fullStars && hasHalfStar) {
              return Icon(Icons.star_half, size: size, color: starColor);
            } else {
              return Icon(Icons.star_border, size: size, color: starColor);
            }
          }),
        ),
        if (showText) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style:
                textStyle ??
                TextStyle(fontSize: size * 0.6, fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }
}
