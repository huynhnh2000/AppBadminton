// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/rollcall_controll.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/online/roll_call_coachs_api.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class NotifyControll{

  final RollCallCoachesApi rollCallCoachesApi = RollCallCoachesApi();
  final RollCallControll rollCallControll = RollCallControll();
  final currentUser = MyCurrentUser();

  Future<void> checkRollCallCoachs(BuildContext context) async{
    try{
      bool isRollCall = await rollCallCoachesApi.checkByCoachsID(currentUser.id!);
      if(isRollCall){
        QuickAlert.show(
          context: context, 
          type: QuickAlertType.success,
          title: AppLocalizations.of(context).translate("rollcall_success"),
        );
      }
      else{
        QuickAlert.show(
          context: context, 
          type: QuickAlertType.error,
          title: AppLocalizations.of(context).translate("rollcall_fail"),
          confirmBtnText: AppLocalizations.of(context).translate("rollcall"),
          onConfirmBtnTap: () async{
            Navigator.pop(context);
            await rollCallControll.rollCallCoachs(context);
          },
        );
      }
    }
    catch(e){
      log("$e");
    }
  }

}