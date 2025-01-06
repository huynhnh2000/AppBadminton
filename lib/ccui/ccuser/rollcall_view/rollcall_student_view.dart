
import 'package:badminton_management_1/bbcontroll/state/list_rollcallstudent_provider.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_roll_call.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/online/roll_call_api.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/loading/loading_list_student_view.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/big_one_shimmer.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/shimmer_loading.dart';
import 'package:badminton_management_1/ccui/ccitem/rollcall_student_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class RollCallStudentHistoryView extends StatefulWidget{
  const RollCallStudentHistoryView({super.key});
  
  @override
  State<RollCallStudentHistoryView> createState() => _RollCallStudentHistoryView();
}

class _RollCallStudentHistoryView extends State<RollCallStudentHistoryView>{

  final currentUser = MyCurrentUser();
  final RollCallApi rollCallApi = RollCallApi();

  DateTime chooseDay = DateTime.now();

  CalendarFormat calendarFormat = CalendarFormat.month;
  ListRollcallStudentProvider rcStudent = ListRollcallStudentProvider();

  @override
  void initState() {
    rcStudent = Provider.of<ListRollcallStudentProvider>(context, listen: false);
    rcStudent.setList();
    super.initState();
  }

  @override
  void dispose() {
    rcStudent.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: AppMainsize.mainWidth(context),
      height: AppMainsize.mainHeight(context),
      color: AppColors.pageBackground,
      child: SafeArea(
        child: Consumer<ListRollcallStudentProvider>(
          builder: (context, value, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //------------------------
                  Expanded(
                    flex: 0,
                    child: TableCalendar(
                      focusedDay: chooseDay, 
                      firstDay: DateTime.parse(currentUser.startDay!), 
                      lastDay: DateTime(DateTime.now().year+1),
                      calendarFormat: calendarFormat,
                      onFormatChanged: (format){
                        setState(() {
                          calendarFormat = format;
                        });
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) => buildDayCell(day, value.lstRC),
                        selectedBuilder: (context, day, focusedDay) => buildDayCell(day, value.lstRC, isSelected: true),
                        todayBuilder: (context, day, focusedDay) => buildDayCell(day, value.lstRC, isSelected: true),
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          chooseDay = selectedDay;
                        });
                        value.filterList(DateFormat("yyyy-MM-dd").format(chooseDay));
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(chooseDay, day);
                      },
                    )
                  ),

                  //------------------------
                  Expanded(
                    child: Shimmer(
                      linearGradient: shimmerGradient,
                      child: value.isLoading?
                      ShimmerLoading(
                        isLoading: value.isLoading, 
                        child: const LoadingListView()
                      ):
                      ShimmerLoading(
                        isLoading: value.isLoading, 
                        child: Container(
                          width: AppMainsize.mainWidth(context),
                          color: AppColors.pageBackground,
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: value.lstFilterRC.length,
                            scrollDirection: Axis.vertical,
                            // physics: const ScrollPhysics(),
                            itemBuilder: (context, index){
                              return RollCallStudentItem(rcStudent: value.lstFilterRC[index]);
                            }
                          ),
                        ),
                      )
                    )
                  )
                ],
              );
          },
        )
      )
    );
  }

  Widget buildDayCell(DateTime day, List<MyRollCall> snapshot, {bool isSelected = false}) {
    if (snapshot.isEmpty) {
      return isSelected ? selectedBuilder(0, day) : defaultBuilder(0, day);
    }
    String formatted = DateFormat("yyyy-MM-dd").format(day);

    int count = snapshot.where((rc) => rc.dateUpdated?.split("T")[0] == formatted).length;

    return isSelected ? selectedBuilder(count, day) : defaultBuilder(count, day);
  }

  Widget selectedBuilder(int taskCount, DateTime day) {
    return Container(
      width: 100,
      padding: const EdgeInsets.only(top: 5, right: 5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            day.day.toString(), // Display the day number
            style: const TextStyle(color: Colors.white),
          ),
          if (taskCount > 0) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                "$taskCount",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget defaultBuilder(int taskCount, DateTime day) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            day.day.toString(),
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          if (taskCount > 0) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                "$taskCount",
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

}