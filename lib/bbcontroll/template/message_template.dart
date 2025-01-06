// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/ccui/ccresource/app_message.dart';
import 'package:flutter/material.dart';

class MessageHandler {

  Future<void> handleAction(
    BuildContext context,
    Future<bool> Function() action,
    String successMessageKey,
    String errorMessageKey,
  ) async {
    try {
      bool isSuccess = await action();

      if (isSuccess) {
        AppMessage.successMessage(context, AppLocalizations.of(context).translate(successMessageKey));
      } else {
        AppMessage.errorMessage(context, AppLocalizations.of(context).translate(errorMessageKey));
      }
    } catch (e) {
      AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
      log("Error: $e");
    }
  }

}