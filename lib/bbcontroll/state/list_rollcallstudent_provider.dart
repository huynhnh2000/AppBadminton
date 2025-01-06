// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_roll_call.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/online/roll_call_api.dart';
import 'package:flutter/material.dart';
class ListRollcallStudentProvider with ChangeNotifier{

  List<MyRollCall> _lstRC = [], _lstFilterRC = [];
  List<MyRollCall> get lstRC => _lstRC;
  List<MyRollCall> get lstFilterRC => _lstFilterRC;
  
  final MyCurrentUser currentUser = MyCurrentUser();
  final RollCallApi rollCallApi = RollCallApi();

  bool isLoading = false;

  void clear(){
    _lstRC.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> setList() async{
    try{
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _lstRC = [];
      await Future.delayed(const Duration(seconds: 1));
      _lstRC = await rollCallApi.getListStudentId(currentUser.id!);

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