// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/connection/check_connection.dart';
import 'package:badminton_management_1/bbcontroll/state/list_student_provider.dart';
import 'package:badminton_management_1/bbcontroll/template/message_template.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_facility.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_student.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/online/facility_api.dart';
import 'package:badminton_management_1/bbdata/online/roll_call_api.dart';
import 'package:badminton_management_1/bbdata/online/roll_call_coachs_api.dart';
import 'package:badminton_management_1/ccui/ccresource/app_message.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class RollCallControll{

  final RollCallCoachesApi rollCallCoachesApi = RollCallCoachesApi();
  final FacilityApi facilityApi = FacilityApi();
  final RollCallApi rollCallApi = RollCallApi();
  // final RollCallDatabaseRepository rollcallRepository = RollCallDatabaseRepository();
  final MessageHandler messageHandler = MessageHandler();
  final ConnectionService connectionService = ConnectionService();
  final currentFacility = MyCurrentFacility();
  final listFacility = MyListCurrentFacility();
  final currentUser = MyCurrentUser();

  Future<void> getCurrentPosition() async{
    try{

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          return;
        }
      }
      
      Position position = await Geolocator.getCurrentPosition();
      currentUser.latitude = "${position.latitude}";
      currentUser.longitude = "${position.longitude}";
    }
    catch(e){
      log("$e");
    }
  }

  Future<bool> isNearFacility(BuildContext context) async {
    try{
      const double proximityThreshold = 1000; // 1km
      await listFacility.setList();
      List<MyFacility> lstFacility = listFacility.lstFacility!;
      List<MyFacility> nearbyFacility = [];

      for(var facility in lstFacility){
        double distance = Geolocator.distanceBetween(
          double.parse(currentUser.latitude!),
          double.parse(currentUser.longitude!),
          double.parse(facility.latitude!),
          double.parse(facility.longtitude!)
        );
        if(distance<=proximityThreshold){nearbyFacility.add(facility);}
      }
      if(nearbyFacility.isNotEmpty){currentFacility.setCurrent(nearbyFacility.first);}

      return nearbyFacility.isNotEmpty;
      // return true;
    }
    catch(e){
      return false;
    }
  }

  Future<void> rollCallCoachs(BuildContext context) async {
    try {
      await getCurrentPosition();
      bool isAtWork = await isNearFacility(context);

      if (isAtWork) {
        await Future.delayed(const Duration(seconds: 5));

        bool isHistory = await rollCallCoachesApi.checkByCoachsID(currentUser.id!);

        if (!isHistory) {

          await messageHandler.handleAction(
            context, 
            ()=>rollCallCoachesApi.rollCallCoachs(), 
            "rollcall_success", 
            "error_rollcall"
          );

        } else {
          AppMessage.successMessage(context, AppLocalizations.of(context).translate("rollcall_success"));
        }

      } else {
        AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_rollcall_notatwork"));
      }

    } catch (e) {
      AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_rollcall"));
    }
  }


  // Student Roll Call --------------------------------------------------------

  Future<void> handleSaveListRollCall(BuildContext context) async {
    try {
      bool isConnect = await connectionService.checkConnect();
      await _processRollCallSave(context, isOnline: isConnect);
    } catch (e) {
      AppMessage.errorMessage(context, AppLocalizations.of(context).translate("error_data"));
    }
  }

  // Main function to handle both online and offline saves
  Future<void> _processRollCallSave(BuildContext context, {required bool isOnline}) async {
    final studentProvider = Provider.of<ListStudentProvider>(context, listen: false);

    bool? youSure = await _showConfirmationDialog(
      context,
      title: isOnline
          ? AppLocalizations.of(context).translate("rollcall_check_save")
          : AppLocalizations.of(context).translate("rollcall_check_save_local"),
    );

    if (youSure != true) return;
    
    //
    QuickAlert.show(context: context, type: QuickAlertType.loading, disableBackBtn: true);
    List<MyStudent> studentsToCheck = List<MyStudent>.from(studentProvider.lstUpdateIsCheck);
    bool isAllSuccessful = true;

    for (var std in studentsToCheck) {
      bool isSaved = await _saveRollCallWithRetry(
        std,
        retryLimit: 3,
        isOnline: isOnline,
      );

      if (!isSaved) {
        isAllSuccessful = false;
      } else {
        int index = studentProvider.lstUpdateIsCheck.indexWhere((student) => student.id == std.id);
        studentProvider.deleteFromLstUpdate(index);
        studentProvider.updateSavedRollCall(std);
        // await RollCallDatabaseRepository().deleteItem(std.id!);
      }
    }
    Navigator.pop(context);
    //

    await messageHandler.handleAction(
      context, 
      () async=>isAllSuccessful, 
      AppLocalizations.of(context).translate("success_save"), 
      AppLocalizations.of(context).translate("error_retry_failed")
    );
  }

  // Helper function to show confirmation dialog
  Future<bool?> _showConfirmationDialog(BuildContext context, {required String title}) async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: title,
      showCancelBtn: true,
      onConfirmBtnTap: () {
        Future.microtask(() => Navigator.of(context).pop(true));
      },
      onCancelBtnTap: () {
        Future.microtask(() => Navigator.of(context).pop(false));
      },
    );
  }

  // Retry logic for saving roll call (online or offline)
  Future<bool> _saveRollCallWithRetry(MyStudent std, {required int retryLimit, required bool isOnline}) async {
    int retryCount = 0;
    bool isSaved = false;

    while (!isSaved && retryCount < retryLimit) {
      if (isOnline) {
        isSaved = await rollCallApi.rollCall(std.id!, std.isCheck??"1");
      } 
      // else {
      //   int result = await rollcallRepository.addItem(
      //     MyRollCall(
      //       studentId: std.id ?? "", 
      //       coachId: currentUser.id,
      //       isCheck: std.isCheck,
      //       statusId: std.statusId,
      //       userCreated: currentUser.username,
      //       userUpdated: currentUser.username,
      //       dateCreated: DateTime.now().toIso8601String(),
      //       dateUpdated: DateTime.now().toIso8601String()
      //     )
      //   );
      //   isSaved = result > 0;
      // }

      if (!isSaved) {
        retryCount++;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    
    return isSaved;
  }

  
}