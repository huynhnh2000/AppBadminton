
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:flutter/material.dart';

class LoadingListView extends StatefulWidget{
  const LoadingListView({super.key});

  @override
  State<LoadingListView> createState() => _LoadingListView();
}

class _LoadingListView extends State<LoadingListView>{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppMainsize.mainWidth(context),
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              width: AppMainsize.mainWidth(context),
              height: 100,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        }
      )
    );
  }

}