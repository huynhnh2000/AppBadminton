
import 'package:badminton_management_1/bbdata/aamodel/my_learning_process.dart';
import 'package:badminton_management_1/ccui/ccitem/learning_process_student_item.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_format.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';

class YoutubeStudentItem extends StatefulWidget{
  YoutubeStudentItem({super.key, required this.lp});
  MyLearningProcess lp;

  @override
  State<YoutubeStudentItem> createState() => _YoutubeStudentItem();
}

class _YoutubeStudentItem extends State<YoutubeStudentItem>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppMainsize.mainWidth(context) - 100,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LearningProcessStudentItem(lp: widget.lp),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lp.title ?? "",
              style: AppTextstyle.subTitleStyle.copyWith(fontSize: 20),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Image section
            if (widget.lp.youtubeVideo?.imageUrl != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.network(
                        widget.lp.youtubeVideo?.imageUrl ?? "",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                      ),
                      
                      const Positioned.fill(
                        child: Icon(Icons.play_arrow_rounded, size: 100, color: AppColors.contentColorWhite,),
                      )
                    ],
                  )
                ),
              ),
            const SizedBox(height: 10),

            Text(
              widget.lp.comment ?? "",
              style: AppTextstyle.contentBlackSmallStyle,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 15),

            Text(
              widget.lp.dateUpdated != null
                  ? AppFormat.formatDateTime(widget.lp.dateUpdated??"")
                  : "",
              style: AppTextstyle.contentGreySmallStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

  }

}