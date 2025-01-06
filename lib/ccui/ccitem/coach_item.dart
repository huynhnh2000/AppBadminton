
import 'package:badminton_management_1/bbcontroll/state/list_student_provider.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_coach.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:badminton_management_1/ccui/ccuser/rollcall_view/rollcall_coach_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoachItem extends StatefulWidget{
  CoachItem({super.key, required this.coach, required this.isConnect});
  MyCoach coach;
  bool isConnect;

  @override
  State<CoachItem> createState() => _CoachItem();
}

class _CoachItem extends State<CoachItem>{

  bool isLoadingLP = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ListStudentProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context)=>RollCallCoachHistoryView(coachId: widget.coach.id??"")
              )
            );
          },
          child: _coachItem(context, value),
        );
      },
    );
  }

  Widget _coachItem(BuildContext context, ListStudentProvider value){
    return Container(
      width: AppMainsize.mainWidth(context),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.coach.coachName??"", 
                      style: AppTextstyle.contentBlackSmallStyle, 
                      maxLines: 3, 
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10,),
                    // Another if need

                    Text(
                      widget.coach.email??"", 
                      style: AppTextstyle.contentGreySmallStyle, 
                      maxLines: 3, 
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10,),

                    Text(
                      widget.coach.phone??"", 
                      style: AppTextstyle.contentGreySmallStyle, 
                      maxLines: 3, 
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10,),
                  ],
                )
              ),
            ], 
          )
    );
  }

}