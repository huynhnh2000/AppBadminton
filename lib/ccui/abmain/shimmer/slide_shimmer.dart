import 'package:flutter/material.dart';

class SlidingShimmer extends GradientTransform{

  const SlidingShimmer({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * slidePercent, 
      0.0, 
      0.0
    );
  }

}