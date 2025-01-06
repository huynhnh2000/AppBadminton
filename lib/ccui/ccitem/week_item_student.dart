// import 'package:badminton_management_1/aaconst/aa.dart';
// import 'package:badminton_management_1/aaconst/ab.dart';
// import 'package:badminton_management_1/app_local.dart';
// import 'package:badminton_management_1/bbcontroll/state/list_learningprocess_provider.dart';
// import 'package:badminton_management_1/bbdata/aamodel/my_week.dart';
// import 'package:badminton_management_1/ccui/ccitem/youtube_student_home_item.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class WeekItemStudent extends StatefulWidget{
//   WeekItemStudent({super.key, required this.myWeek});

//   MyWeek myWeek;

//   @override
//   State<WeekItemStudent> createState() => _WeekItemStudent();
// }

// class _WeekItemStudent extends State<WeekItemStudent>{

//   bool isSort = true;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ListLearningprocessProvider>(
//       builder: (context, value, child) {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isSort = !isSort;
//                 });  
//               },
//               child: Container(
//                 width: mainWidth(context),
//                 padding: const EdgeInsets.all(10),
//                 margin: const EdgeInsets.only(bottom: 10, top: 10),
//                 decoration: BoxDecoration(
//                   color: secondColor,
//                   borderRadius: BorderRadius.circular(20)
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       flex: 0,
//                       child: Text(
//                         "${AppLocalizations.of(context).translate("week")} ${widget.myWeek.weekNumber} (${widget.myWeek.dateStartString} - ${widget.myWeek.dateEndString})",
//                         style: contentWhiteSmallStyle,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                       ),
//                     ),

//                     Icon(
//                       isSort?Icons.arrow_drop_down_rounded:Icons.arrow_drop_up_rounded,
//                       color: Colors.white,
//                       size: 45,
//                     )
//                   ],
//                 )
//               ),
//             ),

//             isSort?const SizedBox.shrink():
//             SizedBox(
//               width: mainWidth(context),
//               height: widget.myWeek.lstLP.isEmpty ? 0 : null,
//               child: Scrollbar(
//                 child: ListView.builder(
//                   itemCount: widget.myWeek.lstLP.length,
//                   scrollDirection: Axis.vertical,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return YoutubeStudentItem(lp: widget.myWeek.lstLP[index]);
//                   },
//                 ),
//               ),
//             )

//           ],
//         );
//       },
//     );
//   }

// }