// ignore_for_file: use_build_context_synchronously

// import 'package:badminton_management_1/bbdata/aamodel/my_week.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';

// String amountMonth(String dateString){
//   DateFormat dateFormat =  DateFormat('yyyy-MM');
//   DateTime currentDate = DateTime.now();
//   DateTime date = DateTime.parse(dateString);
//   String month = dateFormat.format(date);
//   DateTime startDate = dateFormat.parse(month);

//   int yearDifference = currentDate.year - startDate.year;
//   int monthDifference = currentDate.month - startDate.month;
//   int totalMonths = yearDifference * 12 + monthDifference;

//   return "$totalMonths";
// }

// List<MyWeek> calculateWeeksInMonth(String monthYear) {

//   List<MyWeek> lstWeek = [];
//   DateFormat format = DateFormat("MM/yyyy");
//   DateTime firstOfMonth = format.parse(monthYear);
//   DateTime lastOfMonth = DateTime(firstOfMonth.year, firstOfMonth.month + 1, 0);

//   DateTime currentWeekStart = firstOfMonth;
//   int weekCounter = 1;

//   while (currentWeekStart.isBefore(lastOfMonth) || currentWeekStart.isAtSameMomentAs(lastOfMonth)) {
//     DateTime currentWeekEnd = currentWeekStart.add(Duration(days: 6 - currentWeekStart.weekday % 7));
//     if (currentWeekEnd.isAfter(lastOfMonth)) {
//       currentWeekEnd = lastOfMonth;
//     }

//     // Format the start and end dates
//     String formattedStart = DateFormat("d/MM/yyyy").format(currentWeekStart);
//     String formattedEnd = DateFormat("d/MM/yyyy").format(currentWeekEnd);

//     lstWeek.add(
//       MyWeek(
//         weekNumber: "$weekCounter", 
//         dateStart: currentWeekStart, dateEnd: currentWeekEnd,
//         dateStartString: formattedStart, dateEndString: formattedEnd
//       )
//     );

//     // Move to the next week (start of next week is the day after current week's end)
//     currentWeekStart = currentWeekEnd.add(const Duration(days: 1));
//     weekCounter++;
//   }

//   return lstWeek;
// }