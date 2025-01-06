
import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/state/list_tuitions_provider.dart';
import 'package:badminton_management_1/bbcontroll/tuition.controll.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_tuitions.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/big_one_shimmer.dart';
import 'package:badminton_management_1/ccui/abmain/shimmer/shimmer_loading.dart';
import 'package:badminton_management_1/ccui/ccitem/chart/line_chart_view.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_format.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:badminton_management_1/ccui/loading/loading_list_student_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticTuitionsStudent extends StatefulWidget{
  const StatisticTuitionsStudent({super.key});

  @override
  State<StatisticTuitionsStudent> createState() => _StatisticTuitionsStudent();
}

class _StatisticTuitionsStudent extends State<StatisticTuitionsStudent>{

  Future<void> initData() async{
    await TuitionControll().setListTuitionWithStudentId(context);
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context)
    );
  }

  Widget _body(BuildContext context){
    return Stack(
      children: [
        
        Container(
          width: AppMainsize.mainWidth(context),
          height: AppMainsize.mainHeight(context),
          color: AppColors.pageBackground,
        ),

        SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            child: Container(
              width: AppMainsize.mainWidth(context),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Center(
                    child: Text(
                      AppLocalizations.of(context).translate("statistic_tuitions"),
                      style: AppTextstyle.mainTitleStyle.copyWith(color: AppColors.secondary),
                    ),
                  ),
                  const SizedBox(height: 30,),

                  Container(
                    width: AppMainsize.mainWidth(context),
                    height: 350,
                    margin: const EdgeInsets.all(10),
                    
                    child: const LineChartView(),
                  ),
                  const SizedBox(height: 30,),

                  _sectionThisMonthStatistic(),
                  const SizedBox(height: 30,),

                  _sectionSummaryMonthStatistic(),
                  const SizedBox(height: 30,),

                  _sectionTuitionsHistory(),
                  const SizedBox(height: 30,),

                ],
              ),
            ),
          )
        )

      ],
    );
  }

  Widget _sectionThisMonthStatistic(){
    return Consumer<ListTuitionsProvider>(
      builder: (context, value, child) {
        return Container(
          width: AppMainsize.mainWidth(context),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).translate("summary_thismonth"),
                style: AppTextstyle.contentWhiteSmallStyle,
              ),
              const SizedBox(height: 10,),

              SizedBox(
                width: AppMainsize.mainWidth(context),
                child: Text(
                  "${AppFormat.formatMoney("${value.thisMonthMoney}")} VND",
                  style: AppTextstyle.subWhiteTitleStyle,
                  overflow: TextOverflow.visible,
                  maxLines: null,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _sectionSummaryMonthStatistic(){
    return Consumer<ListTuitionsProvider>(
      builder: (context, value, child) {
        return Container(
          width: AppMainsize.mainWidth(context),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.contentColorGreen,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).translate("summary_tuitions"),
                style: AppTextstyle.contentWhiteSmallStyle,
              ),
              const SizedBox(height: 10,),

              Text(
                "${AppFormat.formatMoney("${value.sumMoney}")} VND",
                style: AppTextstyle.subWhiteTitleStyle,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTuitionsHistory() {
    return Consumer<ListTuitionsProvider>(
      builder: (context, value, child) {
        return Container(
          width: AppMainsize.mainWidth(context),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).translate("statistic_tuitions_history"),
                style: AppTextstyle.mainTitleStyle,
                overflow: TextOverflow.ellipsis,
              ),

              Shimmer(
                linearGradient: shimmerGradient,
                child: SizedBox(
                  width: AppMainsize.mainWidth(context),
                  child: value.isLoading
                      ? ShimmerLoading(
                          isLoading: value.isLoading,
                          child: const LoadingListView(),
                        )
                      : ShimmerLoading(
                          isLoading: value.isLoading,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.lstYearWithTuitions.length,
                            itemBuilder: (context, index) {
                              final yearEntry = value.lstYearWithTuitions[index];
                              int year = yearEntry.keys.first;
                              List<MyTuitions> tuitions = yearEntry[year]!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10,),
                                  Text(
                                    '$year',
                                    style: AppTextstyle.subTitleStyle,
                                  ),

                                  Wrap(
                                    children: tuitions.map((tuition) {
                                      return Container(
                                        padding: const EdgeInsets.all(15),
                                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                                        decoration: BoxDecoration(
                                          color: AppColors.contentColorGrey.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppFormat.formatDateTime(tuition.dateCreated??tuition.dateUpdated??""),
                                              style: AppTextstyle.contentBlackSmallStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            Text(
                                              "${AppFormat.formatMoney(tuition.money??"")} VND",
                                              style: AppTextstyle.contentBlackSmallStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}