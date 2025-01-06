// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_roll_call_coachs.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/online/roll_call_coachs_api.dart';
import 'package:flutter/material.dart';
class ListRollcallcoachProvider with ChangeNotifier{

  List<MyRollCallCoachs> _lstRC = [], _lstFilterRC = [];
  List<MyRollCallCoachs> get lstRC => _lstRC;
  List<MyRollCallCoachs> get lstFilterRC => _lstFilterRC;
  
  final MyCurrentUser currentUser = MyCurrentUser();
  final RollCallCoachesApi rollCallCoachesApi = RollCallCoachesApi();

  bool isLoading = false;

  void clear(){
    _lstRC.clear();
    _lstFilterRC.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
  
  Future<void> setList(String coachId) async{
    try{
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _lstRC = [];
      await Future.delayed(const Duration(seconds: 1));
      _lstRC = await rollCallCoachesApi.getListByCoachId(coachId);

      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

    }
    catch(e){
      log("$e");
    }
  }

  filterList(String day){
    _lstFilterRC = _lstRC.where((rc) => rc.dateCreated?.split("T")[0] == day).toList();
    notifyListeners();
  }

}