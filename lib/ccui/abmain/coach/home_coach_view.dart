// ignore_for_file: unused_element, use_build_context_synchronously

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/connection/check_connection.dart';
import 'package:badminton_management_1/bbcontroll/notify_controll.dart';
import 'package:badminton_management_1/bbcontroll/rollcall_controll.dart';
import 'package:badminton_management_1/bbcontroll/session_controll.dart';
import 'package:badminton_management_1/bbcontroll/state/list_student_provider.dart';
import 'package:badminton_management_1/bbcontroll/weather_controll.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_weather.dart';
import 'package:badminton_management_1/ccui/aamenu/weather_widget.dart';
import 'package:badminton_management_1/ccui/abmain/coach/list_coach_view.dart';
import 'package:badminton_management_1/ccui/abmain/home_header.dart';
import 'package:badminton_management_1/ccui/abmain/coach/list_student_view.dart';
import 'package:badminton_management_1/ccui/ccresource/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCoachView extends StatefulWidget{
  const HomeCoachView({super.key});

  @override
  State<HomeCoachView> createState() => _HomeCoachView();
}

class _HomeCoachView extends State<HomeCoachView>{

  NotifyControll notifyControll = NotifyControll();
  WeatherControll weatherControll = WeatherControll();
  final currentUser = MyCurrentUser();
  final currentWeather = MyCurrentWather();
  final sessionManager = SessionManager();

  double valueAnimate = 0;

  @override
  void initState() {
    notifyControll.checkRollCallCoachs(context);
    sessionManager.startSession(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeHeaderView(body: _body(context))
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: AppMainsize.mainWidth(context),
      color: AppColors.pageBackground,
      clipBehavior: Clip.none,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _containerWeather(context),
            const SizedBox(height: 30,),

            _buttonRollCallCoachs(context),
            const SizedBox(height: 15,),

            _buttonRollCall(context),
            const SizedBox(height: 15,),

            currentUser.userTypeId=="2"?
            _buttonRollCallCoachHistory(context): const SizedBox.shrink(),
            const SizedBox(height: 15,),
            
          ],
        ),
      )
    );
  }

  Widget _containerWeather(BuildContext context) {
    return Container(
      width: AppMainsize.mainWidth(context) - 100,
      height: 200,
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 3)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //
                Expanded(
                  flex: 2,
                  child: WeatherWidget(weatherCondition: currentWeather.main ?? "clear")
                ),
                const SizedBox(width: 15,),
                
                //
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentWeather.nameCity ?? 'Unknown location',
                        style: AppTextstyle.subTitleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Temperature',
                        style: AppTextstyle.contentGreySmallStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${currentWeather.temp ?? 'N/A'} °C',
                        style: AppTextstyle.subTitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Weather',
                        style: AppTextstyle.contentGreySmallStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentWeather.description ?? 'No description',
                        style: AppTextstyle.subTitleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonRollCall(BuildContext context){
    return Consumer<ListStudentProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () async{
            bool isConnect = await ConnectionService().checkConnect();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ListStudentView(isConnect: isConnect,)));
          },
          child: Container(
            width: AppMainsize.mainWidth(context)-100,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate("rollcall_student"), 
                style: AppTextstyle.subWhiteTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ),
          ),
        );
      },
    );
  }

  Widget _buttonRollCallCoachHistory(BuildContext context){
    return Consumer<ListStudentProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () async{
            bool isConnect = await ConnectionService().checkConnect();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ListCoachView(isConnect: isConnect,)));
          },
          child: Container(
            width: AppMainsize.mainWidth(context)-100,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate("rollcall_coach"), 
                style: AppTextstyle.subWhiteTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ),
          ),
        );
      },
    );
  }

  bool isRollCall = false;
  Widget _buttonRollCallCoachs(BuildContext context){
    return GestureDetector(
      onTap: () async{
        setState(() {
          isRollCall = true;
        });
        await RollCallControll().rollCallCoachs(context);
        setState(() {
          isRollCall = false;
        });
      },
      child: Container(
        width: AppMainsize.mainWidth(context)-100,
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: isRollCall?
            const CircularProgressIndicator(color: AppColors.pageBackground,):
            Text(AppLocalizations.of(context).translate("rollcall"), style: AppTextstyle.subWhiteTitleStyle,)
        ),
      ),
    );
  }


}