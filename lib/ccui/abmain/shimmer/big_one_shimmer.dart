import 'package:badminton_management_1/ccui/abmain/shimmer/slide_shimmer.dart';
import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget{

  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }
  
  const Shimmer({
    super.key,
    required this.linearGradient,
    this.child
  });

  final LinearGradient linearGradient;
  final Widget? child;

  @override
  State<Shimmer> createState() => ShimmerState();
}

// Add methods to the ShimmerState class in order to provide access to the linearGradient, 
// the size of the ShimmerState's RenderBox, 
// and look up the position of a descendant within the ShimmerState's RenderBox.

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin{

  late AnimationController shimmerControll;
  
  Listenable get shimmerChanges => shimmerControll;

  Gradient get gradient => LinearGradient(
    colors: widget.linearGradient.colors,
    stops: widget.linearGradient.stops,
    begin: widget.linearGradient.begin,
    end: widget.linearGradient.end,
    transform: SlidingShimmer(slidePercent: shimmerControll.value)
  );

  bool get isSized => (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({required RenderBox descendant,Offset offset = Offset.zero}) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  @override
  void initState() {
    shimmerControll = AnimationController.unbounded(
      vsync: this,
    )..repeat(
      min: 0.5, max: 2.5,
      period: const Duration(milliseconds: 1000)
    );
    super.initState();
  }

  @override
  void dispose() {
    shimmerControll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }

}