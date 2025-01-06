
import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/learningprocess_controll.dart';
import 'package:badminton_management_1/bbcontroll/state/list_student_provider.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_student.dart';
import 'package:badminton_management_1/ccui/abmain/coach/learning_process_history.dart';
import 'package:badminton_management_1/ccui/ccitem/rollcall_student_button.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentItem extends StatefulWidget{
  StudentItem({super.key, required this.student, required this.isConnect});
  MyStudent student;
  IconData iconCheck = Icons.circle_outlined;
  bool isConnect;

  @override
  State<StudentItem> createState() => _StudentItem();
}

class _StudentItem extends State<StudentItem>{

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

    if(widget.student.isCheck=="0"){
      widget.iconCheck = Icons.circle_outlined;
    }
    else{
      widget.iconCheck = Icons.check_circle;
    }

    return Consumer<ListStudentProvider>(
      builder: (context, value, child) {
        return RollcallStudentButton(
          student: widget.student,
          provider: value, 
          child: _studentItem(context, value),
        );
      },
    );
  }

  Widget _studentItem(BuildContext context, ListStudentProvider value){
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
                      widget.student.studentName!, 
                      style: AppTextstyle.contentBlackSmallStyle, 
                      maxLines: 3, 
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10,),
                    Text(
                      widget.student.isSavedRollCall?
                      AppLocalizations.of(context).translate("in_rollcall"):
                      AppLocalizations.of(context).translate("out_rollcall"),
                      style: widget.student.isSavedRollCall
                        ? AppTextstyle.contentGreenSmallStyle : AppTextstyle.contentGreySmallStyle,
                    ),

                    const SizedBox(height: 10,),
                    widget.student.isCheck!=null?
                    Text(
                      widget.student.isCheck=="1"?
                      AppLocalizations.of(context).translate("in_class"):
                      AppLocalizations.of(context).translate("out_class"),
                      style: widget.student.isCheck=="1"
                        ? AppTextstyle.contentGreenSmallStyle : AppTextstyle.contentRedSmallStyle,
                    ):
                    const SizedBox.shrink()
                    // Another if need
                  ],
                )
              ),

              !widget.isConnect? const SizedBox():
              Expanded(
                flex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async{
                        setState(() {isLoadingLP = true;});
                        await LearningProcessControll().handleGetLearningProcess(context, widget.student);
                        setState(() {isLoadingLP = false;});
                      }, 
                      icon: isLoadingLP?
                        const Stack(children: [Center(child: CircularProgressIndicator(color: AppColors.secondary,),)],):
                        const Icon(Icons.edit_document, color: Colors.grey, size: 25,)
                    ),

                    IconButton(
                      onPressed: () async{
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context)=>LearningProcessHistoryView(student: widget.student,))
                        );
                      }, 
                      icon: const Icon(Icons.history, color: Colors.grey, size: 25,)
                    )
                  ],
                )
              )
            ], 
          )
    );
  }

}