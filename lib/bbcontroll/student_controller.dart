// ignore_for_file: use_build_context_synchronously

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/state/list_student_provider.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/ccui/ccresource/app_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentControll {
  final currentUser = MyCurrentUser();

  Future<void> handleGetStudents(BuildContext context) async {
    try {
      if (currentUser.userTypeId == "2") {
        await _handleGetAllStudent(context);
      } else {
        await _handleGetStudentsByCoachID(context);
      }
    } catch (e) {
      AppMessage.errorMessage(
          context, AppLocalizations.of(context).translate("error_data"));
    }
  }

  Future<void> _handleGetStudentsByCoachID(BuildContext context) async {
    try {
      final studentProvider =
          Provider.of<ListStudentProvider>(context, listen: false);
      studentProvider.clearLstUpdateIsCheck();

      await studentProvider.setList(() {
        AppMessage.errorMessage(context, "Không có học viên trong danh sách");
      });

      if (studentProvider.lstStudent.isEmpty) {
        AppMessage.errorMessage(
            context, AppLocalizations.of(context).translate("error_data"));
      }
    } catch (e) {
      AppMessage.errorMessage(
          context, AppLocalizations.of(context).translate("error_data"));
    }
  }

  Future<void> _handleGetAllStudent(BuildContext context) async {
    try {
      final studentProvider =
          Provider.of<ListStudentProvider>(context, listen: false);
      studentProvider.clearLstUpdateIsCheck();

      await studentProvider.setListAllStudent(() {
        AppMessage.errorMessage(context, "Không có học viên trong danh sách");
      });

      if (studentProvider.lstStudent.isEmpty) {
        AppMessage.errorMessage(
            context, AppLocalizations.of(context).translate("error_data"));
      }
    } catch (e) {
      AppMessage.errorMessage(
          context, AppLocalizations.of(context).translate("error_data"));
    }
  }
}
