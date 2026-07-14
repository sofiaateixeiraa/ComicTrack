import 'package:flutter/material.dart';

class SeriesCoverPlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const SeriesCoverPlaceholder({super.key, this.width = 40, this.height = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/icons/logo-cover.png',
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
    );
  }
}
