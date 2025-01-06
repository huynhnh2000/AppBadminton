// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:badminton_management_1/ccui/abmain/shimmer/big_one_shimmer.dart';
import 'package:flutter/material.dart';

const shimmerGradient = LinearGradient(
  colors: [
    Colors.grey,
    Color(0xFFF4F4F4),
    Colors.grey,
  ],
  stops: [0.1, 0.2, 0.3],
  begin: Alignment(-2.5, -0.5),
  end: Alignment(2.0, 0.5),
  tileMode: TileMode.clamp,
);


class ShimmerLoading extends StatefulWidget{
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoading();
}

class _ShimmerLoading extends State<ShimmerLoading>{

  Listenable? _shimmerChanges;

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.isLoading){
      return widget.child;
    }

    //----
    
    final shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      return const SizedBox();
    }

    final gradient = shimmer.gradient;
    final shimmerSize = shimmer.size;
    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bound){
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx, 
            -offsetWithinShimmer.dy, 
            shimmerSize.width, 
            shimmerSize.height
          )
        );
      },
      child: widget.child,
    );
  }

}