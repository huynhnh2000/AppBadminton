import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_tuitions.dart';
import 'package:badminton_management_1/bbdata/online/tuition_api.dart';
import 'package:flutter/material.dart';

class ListTuitionsProvider with ChangeNotifier{

  List<MyTuitions> _lstTuition = [];
  List<MyTuitions> get lstTuition => _lstTuition;

  List<Map<int, List<MyTuitions>>> lstYearWithTuitions = [];
  List<Map<int, double>> lstMoneyThisYear = [];
  List<Map<int, double>> lstMoneyAllYear = [];

  double sumMoney = 0;
  double thisMonthMoney = 0;
  bool isLoading = false;

  // Set for isLoading
  void _setLoadingState(bool loading) {
    isLoading = loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Set list tuition
  Future<void> setList() async {
    _setLoadingState(true);

    try {
      _lstTuition.clear();
      _lstTuition = await TuitionApi().getList();
      _lstTuition.sort((a, b) => DateTime.parse(b.dateUpdated??"").compareTo(DateTime.parse(a.dateCreated??"")));

    } catch (e) {
      log("$e");
    } finally {
      _setLoadingState(false);
    }
  }

  // Summary money of this month
  void setThisMonthMoney() {
    if (_lstTuition.isNotEmpty) {
      
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;

      thisMonthMoney = _lstTuition
          .where((tuition){
            int tuitionMonth = DateTime.parse(tuition.dateUpdated??"").month;
            int tuitionYear = DateTime.parse(tuition.dateUpdated??"").year;

            return tuitionMonth == currentMonth && tuitionYear == currentYear;
          })
          .fold(0, (previousValue, tuition) => previousValue + (double.parse(tuition.money??"0")));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Summary money of all time
  void setSummaryMoney() {
    if (_lstTuition.isNotEmpty) {

      sumMoney = _lstTuition
          .fold(0, (previousValue, tuition) => previousValue + (double.parse(tuition.money??"0")));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Set list of year have children list tuition
  void setListYearWithTuitions(){
    lstYearWithTuitions.clear();

    Map<int, List<MyTuitions>> groupedByYear = {};

    for (var tuition in _lstTuition) {
      DateTime tuitionDate = DateTime.parse(tuition.dateUpdated ?? tuition.dateCreated ?? "");
      int year = tuitionDate.year;

      if (!groupedByYear.containsKey(year)) {
        groupedByYear[year] = [];
      }
      groupedByYear[year]!.add(tuition);
    }

    lstYearWithTuitions = groupedByYear.entries
        .map((entry) => {entry.key: entry.value})
        .toList();

    lstYearWithTuitions = lstYearWithTuitions..sort((a, b) => b.keys.first.compareTo(a.keys.first));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Set list money of 12 month this year
  void setListMoneyThisYear(){
    lstMoneyThisYear.clear();

    int currentYear = DateTime.now().year;
    Map<int, double> monthlyTotals = {};

    for (int month = 1; month <= 12; month++) {
      monthlyTotals[month] = 0;
    }

    for (var tuition in _lstTuition) {
      DateTime tuitionDate = DateTime.parse(tuition.dateUpdated ?? tuition.dateCreated ?? "");
      int year = tuitionDate.year;
      int month = tuitionDate.month;

      if (year == currentYear) {
        double money = double.parse(tuition.money ?? "0");
        monthlyTotals[month] = (monthlyTotals[month] ?? 0) + money;
      }
    }

    lstMoneyThisYear = monthlyTotals.entries
        .map((entry) => {entry.key: entry.value})
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Set list of money totals for each year in _lstTuition
  void setListMoneyAllYear() {
    lstMoneyAllYear.clear();

    Map<int, double> yearlyTotals = {};

    for (var tuition in _lstTuition) {
      DateTime tuitionDate = DateTime.parse(tuition.dateUpdated ?? tuition.dateCreated ?? "");
      int year = tuitionDate.year;
      double money = double.parse(tuition.money ?? "0");

      if (yearlyTotals.containsKey(year)) {
        yearlyTotals[year] = yearlyTotals[year]! + money;
      } else {
        yearlyTotals[year] = money;
      }
    }

    lstMoneyAllYear = yearlyTotals.entries
        .map((entry) => {entry.key: entry.value})
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

}