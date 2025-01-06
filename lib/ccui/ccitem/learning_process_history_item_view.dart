
import 'package:badminton_management_1/bbdata/aamodel/my_learning_process.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_student.dart';
import 'package:badminton_management_1/ccui/ccitem/learning_process_coach_item.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_format.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';

class LearningProcessHistoryItem extends StatefulWidget{
  LearningProcessHistoryItem({super.key, required this.myLP, required this.myStudent});
  MyLearningProcess myLP;
  MyStudent myStudent;

  @override
  State<LearningProcessHistoryItem> createState() => _LearningProcessHistoryItem();
}

class _LearningProcessHistoryItem extends State<LearningProcessHistoryItem>{

  bool isLoadingRC = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppMainsize.mainWidth(context),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.myLP.title??"", 
                  style: AppTextstyle.contentBlackSmallStyle, 
                  maxLines: 3, 
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10,),

                Text(
                  widget.myLP.comment??"", 
                  style: AppTextstyle.contentGreySmallStyle, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10,),

                Text(
                  AppFormat.formatDateTime(widget.myLP.dateUpdated??""), 
                  style: AppTextstyle.contentGreySmallStyle, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context)=>LearningProcessItem(student: widget.myStudent, learningProcess: widget.myLP, isNullLP: false)
                )
              );
            }, 
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(100)
              ),
              child: const Center(child: Icon(Icons.edit, color: Colors.white, size: 18,),),
            )
          )
        ],
      )
    );
  }

}