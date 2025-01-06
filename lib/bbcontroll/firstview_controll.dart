// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/connection/check_connection.dart';
import 'package:badminton_management_1/bbcontroll/rollcall_controll.dart';
import 'package:badminton_management_1/bbcontroll/strategy/user_type.dart';
import 'package:badminton_management_1/bbcontroll/weather_controll.dart';
import 'package:badminton_management_1/ccui/ccresource/app_message.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';


Future<void> durationAwait(BuildContext context, UserTypeStrategy userTypeStrategy) async {
  try {
    await Future.delayed(const Duration(seconds: 1));

    bool isConnect = await ConnectionService().checkConnect().timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return false;
      },
    );

    if (isConnect) {
      
      await WeatherControll().getCurrentWeather().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_timeout"));
        },
      );

      await RollCallControll().getCurrentPosition().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_timeout"));
        },
      );

      UserTypeContext.strategy = userTypeStrategy;
      UserTypeContext.navigateReplacement(context, "/signin");
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: AppLocalizations.of(context).translate("error_connect_lost"),
      );
    }
  } catch (e) {
    AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
  }
}
