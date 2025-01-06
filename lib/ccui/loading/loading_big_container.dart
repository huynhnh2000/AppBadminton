import 'package:flutter/material.dart';

class LoadingBigContainerView extends StatefulWidget{
  LoadingBigContainerView({super.key, required this.width, required this.height});

  double width, height;

  @override
  State<LoadingBigContainerView> createState() => _LoadingBigContainerView();
}

class _LoadingBigContainerView extends State<LoadingBigContainerView>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

}