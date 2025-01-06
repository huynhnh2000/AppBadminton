// ignore_for_file: use_build_context_synchronously

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/state/list_coach_provider.dart';
import 'package:badminton_management_1/bbcontroll/template/message_template.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/online/coach_api.dart';
import 'package:badminton_management_1/ccui/ccresource/app_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoachControll{

  final CoachApi coachApi = CoachApi();
  final MessageHandler messageHandler = MessageHandler();
  final currentUser = MyCurrentUser();

  Future<void> handleGetAllCoach(BuildContext context) async{
    try{
      final coachProvider = Provider.of<ListCoachProvider>(context, listen: false);
      await coachProvider.setListOnline();
      
      if(coachProvider.lstCoach.isEmpty){
        AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
      }

    }
    catch(e){
      AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
    }
  }

}