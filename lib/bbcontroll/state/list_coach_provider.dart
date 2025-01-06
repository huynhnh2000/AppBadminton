import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_coach.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_roll_call_coachs.dart';
import 'package:badminton_management_1/bbdata/online/coach_api.dart';
import 'package:flutter/material.dart';

class ListCoachProvider with ChangeNotifier{

  List<MyCoach> _lstCoach = [];
  List<MyCoach> get lstCoach => _lstCoach;
  
  List<MyCoach> _filterCoach = [];
  List<MyCoach> get lstCoachFilter => _filterCoach.isEmpty ? _lstCoach : _filterCoach;

  List<MyRollCallCoachs> _lstRollCall = [];
  List<MyRollCallCoachs> get lstRollCall => _lstRollCall;

  String _searchQuery = '';
  bool isLoading = false;

  CoachApi coachApi = CoachApi();

  // Set for isLoading
  void _setLoadingState(bool loading) {
    isLoading = loading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> setListOnline() async {
    _setLoadingState(true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      _lstCoach.clear();
      _filterCoach.clear();
      
      _lstCoach = await coachApi.getAllCoach();

      _lstCoach = _lstCoach.where((coach) => coach.statusId == "0").toList();

    } catch (e) {
      log("$e");
    } finally {
      _setLoadingState(false);
    }
  }

  // For search or filter
  void _filterList() {
    final searchQueryTrimmed = _searchQuery.trim().replaceAll(RegExp(r'\s+'), '');

    _filterCoach = _lstCoach.where((coach) {

      final bool matchesSearch = _searchQuery.isEmpty || _searchQuery=="" ||
                                 coach.coachName!.toLowerCase().replaceAll(RegExp(r'\s+'), '').contains(searchQueryTrimmed.toLowerCase().trim()) ||
                                 coach.phone!.toLowerCase().replaceAll(RegExp(r'\s+'), '').contains(searchQueryTrimmed.toLowerCase().trim()) ||
                                 coach.email!.toLowerCase().replaceAll(RegExp(r'\s+'), '').contains(searchQueryTrimmed.toLowerCase().trim());
      
      return matchesSearch;
    }).toList();
    notifyListeners();
  }

  // For search
  void filterListSearch(String query) {
    _searchQuery = query;
    _filterList();
  }

}