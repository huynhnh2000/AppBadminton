// import 'package:badminton_management_1/aaconst/aa.dart';
// import 'package:badminton_management_1/aaconst/ab.dart';
// import 'package:badminton_management_1/bbcontroll/state/list_learningprocess_provider.dart';
// import 'package:badminton_management_1/bbdata/aamodel/my_learning_process.dart';
// import 'package:badminton_management_1/ccui/ccitem/learning_process_student_item.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class LearningProcessStudentList extends StatefulWidget{
//   const LearningProcessStudentList({super.key});

//   @override
//   State<LearningProcessStudentList> createState() => _LearningProcessStudentList();
// }

// class _LearningProcessStudentList extends State<LearningProcessStudentList>{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const ScrollPhysics(),
//         child: _body(context),
//       ),
//     );
//   }

//   Widget _body(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: mainWidth(context),
//           height: mainHeight(context),
//           color: backgroundColor,
//         ),

//         Container(
//           width: mainWidth(context),
//           color: backgroundColor,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sectionLearningProcessNewest(context),
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   Widget _sectionLearningProcessNewest(BuildContext context) {
//     return Container(
//       width: mainWidth(context),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//       ),
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             Expanded(
//               flex: 0,
//               child: Container(
//                 padding: const EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.withOpacity(0.5)),
//                   borderRadius: BorderRadius.circular(20)
//                 ),
//                 child: _dropdownButton(),
//               )
//             ),
            
//             Consumer<ListLearningprocessProvider>(
//               builder: (context, value, child) {
//                 if (value.isLoading) {
//                   return Center(child: CircularProgressIndicator(color: mainColor));
//                 } else if (value.lstLP1.isEmpty) {
//                   return Center(
//                     child: Text(
//                       "No learning processes available",
//                       style: contentGreySmallStyle,
//                     ),
//                   );
//                 } else {
//                   return Container(
//                     width: mainWidth(context),
//                     padding: const EdgeInsets.all(10),
//                     child: ListView.builder(
//                       itemCount: value.lstLP1.length,
//                       scrollDirection: Axis.vertical,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return _lpItem(context, value.lstLP1[index]);
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       )
//     );
//   }

//   Widget _lpItem(BuildContext context, MyLearningProcess lp) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context)=>LearningProcessStudentItem(lp: lp))
//         );
//       },
//       child: Container(
//         width: mainWidth(context) - 50,
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(vertical: 15),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.withOpacity(0.2), width: 3),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               lp.title ?? "",
//               style: subTitleStyle,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 5),
//             Text(
//               lp.comment ?? "",
//               style: contentGreySmallStyle,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 5),
//             Text(
//               lp.dateCreated != null
//                   ? DateFormat('yyyy-MM-dd').format(DateTime.parse(lp.dateCreated!))
//                   : "No date available",
//               style: contentGreySmallStyle,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _dropdownButton() {
//     return Consumer<ListLearningprocessProvider>(
//       builder: (context, value, child) {
//         return DropdownButton<String>(
//           value: value.currentDropdownValue,
//           icon: const Icon(Icons.arrow_downward_rounded, size: 25, color: Colors.grey),
//           elevation: 16,
//           isExpanded: true,
//           underline: const SizedBox.shrink(),
//           borderRadius: BorderRadius.circular(20),
//           style: contentBlackSmallStyle,
//           onChanged: (String? currentValue) {
//             value.currentDropdownValue = currentValue??value.currentDropdownValue;
//             value.filterAllList(context);
//           },
//           items: value.lstDropdown(context).map<DropdownMenuItem<String>>(
//             (value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(
//                   value,
//                   style: contentBlackSmallStyle,
//                   softWrap: true,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//               );
//             },
//           ).toList(),
//         );
//       },
//     );
//   }

// }