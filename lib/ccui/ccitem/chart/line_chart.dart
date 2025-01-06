

import 'package:badminton_management_1/bbcontroll/state/list_tuitions_provider.dart';
import 'package:badminton_management_1/ccui/ccresource/app_format.dart';
import 'package:badminton_management_1/ccui/ccresource/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartModel extends StatelessWidget{

  LineChartModel({super.key, required this.isYearData, required this.tuitionProvider});
  bool isYearData;
  ListTuitionsProvider tuitionProvider;

  LineChartData get mainDataMonth => LineChartData(
    minX: 0, minY: 0,
    maxX: 14, maxY: 5,
    lineTouchData: lineTouchMonthData,
    gridData: gridData,
    titlesData: titleMonthData,
    borderData: borderData,
    lineBarsData: [
      lineChartBarDataMonth
    ],
  );

  LineChartData get mainDataYear => LineChartData(
    minX: 0, minY: 0,
    maxX: double.parse("${tuitionProvider.lstMoneyAllYear.length+2}"), maxY: 5,
    lineTouchData: lineTouchYearData,
    gridData: gridData,
    titlesData: titleYearData,
    borderData: borderData,
    lineBarsData: [
      lineChartBarDataYear
    ],
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = AppMainsize.mainWidth(context);

    double chartWidth = (isYearData ? mainDataYear.maxX : mainDataMonth.maxX) * 75;
    if (chartWidth < screenWidth) {
      chartWidth = screenWidth + 20; 
    }

    return SizedBox(
      height: 700,
      width: screenWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(
            width: chartWidth,
            padding: const EdgeInsets.only(top: 20),
            child: LineChart(
              isYearData ? mainDataYear : mainDataMonth,
              duration: const Duration(milliseconds: 300),
            ),
          );
        },
      ),
    );
  }

  LineTouchData get lineTouchMonthData => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touched) => Colors.grey.withOpacity(0.1),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          List<double> monthlyValues = List.generate(12, (index) {
            int month = index + 1;
            return tuitionProvider.lstMoneyThisYear.firstWhere(
              (map) => map.keys.first == month,
              orElse: () => {month: 0.0},
            )[month]!;
          });

          return touchedSpots.map((spot) {
            int month = spot.x.toInt();
            double moneyValue = monthlyValues[month - 1];
            return LineTooltipItem(
              '${AppFormat.formatMoney(moneyValue.toStringAsFixed(2))} VND',
              AppTextstyle.contentBlackSmallStyle.copyWith(fontSize: 12),
            );
          }).toList();
        },
      ),
  );

  LineTouchData get lineTouchYearData => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touched) => Colors.grey.withOpacity(0.1),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {

          List<double> yearlyValues = List.generate(tuitionProvider.lstMoneyAllYear.length, (index) {
            int year = tuitionProvider.lstMoneyAllYear[index].keys.first;
            return tuitionProvider.lstMoneyAllYear[index][year]!;
          });

          return touchedSpots.map((spot) {
            int year = spot.x.toInt();
            double moneyValue = yearlyValues[year - 1];
            return LineTooltipItem(
              '${AppFormat.formatMoney(moneyValue.toStringAsFixed(2))} VND',
              AppTextstyle.contentBlackSmallStyle.copyWith(fontSize: 12),
            );
          }).toList();
        },
      ),
  );

  FlGridData get gridData => const FlGridData(
    show: true,
  );  

  FlTitlesData get titleYearData => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitlesYear,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftYearTitles,
    ),
  );

  FlTitlesData get titleMonthData => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitlesMonth,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftMonthTitles,
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Colors.transparent),
      left: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData get lineChartBarDataMonth {
    // Extract monthly values from lstMoneyThisYear
    List<double> monthlyValues = List.generate(12, (index) {
      int month = index + 1;
      return tuitionProvider.lstMoneyThisYear.firstWhere(
        (map) => map.keys.first == month,
        orElse: () => {month: 0.0},
      )[month]!;
    });

    // Calculate min and max values for normalization
    // double minValue = monthlyValues.reduce((a, b) => a < b ? a : b);
    double minValue = 0;
    double maxValue = tuitionProvider.lstMoneyThisYear.fold(0, (sum, map) => sum + map.values.first);

    // Normalize monthly values to a range of 1 to 4
    List<FlSpot> spots = List.generate(12, (index) {
      double value = monthlyValues[index];
      double normalizedValue = minValue == maxValue 
        ? 1  // Avoid division by zero if all values are the same
        : 1 + ((value - minValue) * (4 - 1)) / (maxValue - minValue);
      return FlSpot((index + 1).toDouble(), normalizedValue);
    });

    return LineChartBarData(
      isCurved: false,
      color: AppColors.primary,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.5), AppColors.primary.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      spots: spots,
    );
  }

  LineChartBarData get lineChartBarDataYear {
    // Extract yearly values from lstMoneyAllYear
    List<double> yearlyValues = List.generate(tuitionProvider.lstMoneyAllYear.length, (index) {
      int year = tuitionProvider.lstMoneyAllYear[index].keys.first;
      return tuitionProvider.lstMoneyAllYear[index][year]!;
    });

    // Calculate min and max values for normalization
    // double minValue = yearlyValues.reduce((a, b) => a < b ? a : b);
    double minValue = 0;
    double maxValue = tuitionProvider.lstMoneyAllYear.fold(0, (sum, map) => sum + map.values.first);

    // Normalize yearly values to a range of 1 to 4
    List<FlSpot> spots = List.generate(tuitionProvider.lstMoneyAllYear.length, (index) {
      double value = yearlyValues[index];
      double normalizedValue = minValue == maxValue 
        ? 1  // Avoid division by zero if all values are the same
        : 1 + ((value - minValue) * (4 - 1)) / (maxValue - minValue);
      return FlSpot((index + 1).toDouble(), normalizedValue);
    });

    return LineChartBarData(
      isCurved: false,
      color: AppColors.primary,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.5), AppColors.primary.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      spots: spots,
    );
  }


  //------------------------------

  SideTitles get bottomTitlesYear => SideTitles(
    showTitles: true,
    reservedSize: 50,
    interval: 1,
    getTitlesWidget: bottomTitleYearWidgets
  );

  SideTitles get bottomTitlesMonth => SideTitles(
    showTitles: true,
    reservedSize: 50,
    interval: 1,
    getTitlesWidget: bottomTitleMonthWidgets
  );

  SideTitles get leftMonthTitles => SideTitles(
    showTitles: true,
    reservedSize: 50,
    interval: 1,
    getTitlesWidget: leftTitleMonthWidgets
  );

  SideTitles get leftYearTitles => SideTitles(
    showTitles: true,
    reservedSize: 50,
    interval: 1,
    getTitlesWidget: leftTitleYearWidgets
  );

  Widget bottomTitleMonthWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('JAN', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 2:
        text = Text('FEB', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 3:
        text = Text('MAR', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 4:
        text = Text('APR', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 5:
        text = Text('MAY', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 6:
        text = Text('JUN', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 7:
        text = Text('JUL', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 8:
        text = Text('AUG', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 9:
        text = Text('SEP', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 10:
        text = Text('OCT', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 11:
        text = Text('NOV', style: AppTextstyle.contentBlackSmallStyle);
        break;
      case 12:
        text = Text('DEC', style: AppTextstyle.contentBlackSmallStyle);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Widget bottomTitleYearWidgets(double value, TitleMeta meta) {
    Widget text;
    
    List<int> yearList = tuitionProvider.lstMoneyAllYear.map((entry) => entry.keys.first).toList();

    // Check if value corresponds to a valid index in yearList
    int index = value.toInt() - 1;
    if (index >= 0 && index < yearList.length) {
      text = Text('${yearList[index]}', style: AppTextstyle.contentBlackSmallStyle);
    } else {
      text = const SizedBox.shrink();
    }
    // if (index >= 0 && index < 20) {
    //   text = Text('${yearList[0]}', style: AppTextstyle.contentBlackSmallStyle);
    // } else {
    //   text = const SizedBox.shrink();
    // }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Widget leftTitleMonthWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    String text;
    
    double sumMoney = tuitionProvider.lstMoneyThisYear.fold(0, (sum, map) => sum + map.values.first);
    double quarterValue = sumMoney / 3;
    List<String> lstText = [
      ("0"), // 0% of sumMoney
      (AppFormat.formatMoney((quarterValue * 1).toStringAsFixed(1))), // 25% of sumMoney
      (AppFormat.formatMoney((quarterValue * 2).toStringAsFixed(1))), // 50% of sumMoney
      (AppFormat.formatMoney((quarterValue * 3).toStringAsFixed(1))), // 75% of sumMoney
    ];

    switch (value.toInt()) {
      case 1:
        text = lstText[0];
        break;
      case 2:
        text = lstText[1];
        break;
      case 3:
        text = lstText[2];
        break;
      case 4:
        text = lstText[3];
        break;
      default:
        return const SizedBox.shrink();
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget leftTitleYearWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    String text;
    
    double totalMoney  = tuitionProvider.lstMoneyAllYear.fold(0, (sum, map) => sum + map.values.first);
    double quarterValue = totalMoney / 3;
    List<String> lstText = [
      ("0"), // 0% of sumMoney
      (AppFormat.formatMoney((quarterValue * 1).toStringAsFixed(1))), // 25% of sumMoney
      (AppFormat.formatMoney((quarterValue * 2).toStringAsFixed(1))), // 50% of sumMoney
      (AppFormat.formatMoney((quarterValue * 3).toStringAsFixed(1))), // 75% of sumMoney
    ];

    switch (value.toInt()) {
      case 1:
        text = lstText[0];
        break;
      case 2:
        text = lstText[1];
        break;
      case 3:
        text = lstText[2];
        break;
      case 4:
        text = lstText[3];
        break;
      default:
        return const SizedBox.shrink();
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

}