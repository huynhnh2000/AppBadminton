// ignore_for_file: use_build_context_synchronously

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/state/list_tuitions_provider.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/ccui/ccresource/app_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TuitionControll{

  final currentUser = MyCurrentUser();

  Future<void> setListTuitionWithStudentId(BuildContext context) async{
    try{
      final tuitionProvider = Provider.of<ListTuitionsProvider>(context, listen: false);
      await tuitionProvider.setList();
      tuitionProvider.setSummaryMoney();
      tuitionProvider.setThisMonthMoney();
      tuitionProvider.setListYearWithTuitions();
      tuitionProvider.setListMoneyThisYear();
      tuitionProvider.setListMoneyAllYear();

      if(tuitionProvider.lstTuition.isEmpty){
        AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
      }
    }
    catch(e){
      AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
    }
  }
}