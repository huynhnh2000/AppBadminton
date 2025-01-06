import 'dart:async';
import 'package:badminton_management_1/bbcontroll/strategy/user_type.dart';
import 'package:badminton_management_1/ccui/ccresource/app_resources.dart';
import 'package:flutter/material.dart';

class SessionManager {
  DateTime? _loginTime;
  Timer? _timer;

  void startSession(BuildContext context) {
    _loginTime = DateTime.now();

    // Cancel any existing timer
    _timer?.cancel();

    // Set up a new timer that triggers after 50 minutes (3000 seconds)
    _timer = Timer(const Duration(minutes: 50), () {
      _showSessionExpiredDialog(context);
    });
  }

  _showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: Navigator.of(context, rootNavigator: true).context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Phiên đăng nhập hết hạn", style: AppTextstyle.mainTitleStyle,),
          content: Text("Phiên đăng nhập của bạn đã hết hạn, vui lòng đăng nhập lại!", style: AppTextstyle.contentBlackSmallStyle.copyWith(fontWeight: FontWeight.w300)),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                UserTypeContext.navigateReplacement(context, "/signin");
              },
            ),
          ],
        );
      },
    );
  }


  void stopSession() {
    _timer?.cancel();
  }
}
