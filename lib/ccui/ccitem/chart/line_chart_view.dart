
import 'package:badminton_management_1/bbcontroll/state/list_tuitions_provider.dart';
import 'package:badminton_management_1/ccui/ccitem/chart/line_chart.dart';
import 'package:badminton_management_1/ccui/ccresource/app_colors.dart';
import 'package:badminton_management_1/ccui/ccresource/app_mainsize.dart';
import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LineChartView extends StatefulWidget{
  const LineChartView({super.key});

  @override
  State<LineChartView> createState() => _LineChartView();
}

class _LineChartView extends State<LineChartView>{

  bool isYearData = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ListTuitionsProvider>(
      builder: (context, value, child) {
        return AspectRatio(
          aspectRatio: 0.23,
          child: Container(
            width: AppMainsize.mainWidth(context),
            height: 270,
            padding: const EdgeInsets.only(top: 20, bottom: 0, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  flex: 0,
                  child: IconButton(
                    onPressed: (){
                      setState(() {
                        isYearData = !isYearData;
                      });
                    }, 
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Icon(Icons.restart_alt_outlined, size: 30, color: AppColors.contentColorWhite,),
                    )
                  )
                ),

                isYearData?const SizedBox.shrink():
                SizedBox(
                  width: AppMainsize.mainWidth(context),
                  child: Text(
                    "${DateTime.now().year}",
                    style: AppTextstyle.subSecondTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10,),

                Expanded(
                  child: LineChartModel(isYearData: isYearData, tuitionProvider: value,),
                )
              ],
            )
          )
        );
      },
    );
  }

}