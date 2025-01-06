
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderStudent extends StatefulWidget{
  const SliderStudent({super.key});
  
  double sliderHeight(BuildContext context)=>AppMainsize.mainHeight(context) >= 500 ? 120 : 100;

  @override
  State<SliderStudent> createState() => _SliderStudent();
}

class _SliderStudent extends State<SliderStudent>{

  List<Builder> items = [];

  void initItems() {
    List<String> imagePaths = [
      "assets/slide_img/slide1.jpg",
      "assets/slide_img/slide2.jpg",
      "assets/slide_img/slide3.jpg",
      "assets/slide_img/slide4.jpg",
    ];

    items = imagePaths.map((path) {
      return Builder(
        builder: (context) {
          return SizedBox(
            width: AppMainsize.mainWidth(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(path, fit: BoxFit.cover),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  void initState() {
    initItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppMainsize.mainWidth(context),
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      child: CarouselSlider(
        items: items, 
        options: CarouselOptions(
          height: widget.sliderHeight(context),
          // aspectRatio: 1,
          viewportFraction: 1.0,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 900),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.5,
          scrollDirection: Axis.horizontal,
        )
      ),
    );
  }

}

