// ignore_for_file: use_build_context_synchronously

import 'package:badminton_management_1/ccui/ccresource/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AppMessage {
  static errorMessage(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: AppTextstyle.contentWhiteSmallStyle,),
        backgroundColor: Colors.red,
      ),
    );
  }

  static successMessage(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: AppTextstyle.contentWhiteSmallStyle,),
        backgroundColor: Colors.blue,
      ),
    );
  }

  static void showAlert({required BuildContext context, required QuickAlertType type, required String message}) {
    Future.delayed(Duration.zero, () {
      QuickAlert.show(
        context: context,
        type: type,
        title: message,
      );
    });
  }
}