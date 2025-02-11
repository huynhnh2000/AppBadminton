// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

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
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class RollCallControll {
  final RollCallCoachesApi rollCallCoachesApi = RollCallCoachesApi();
  final FacilityApi facilityApi = FacilityApi();
  final RollCallApi rollCallApi = RollCallApi();
  // final RollCallDatabaseRepository rollcallRepository = RollCallDatabaseRepository();
  final MessageHandler messageHandler = MessageHandler();
  final ConnectionService connectionService = ConnectionService();
  final currentFacility = MyCurrentFacility();
  final listFacility = MyListCurrentFacility();
  final currentUser = MyCurrentUser();

  // Student Roll Call --------------------------------------------------------

  Future<void> handleSaveListRollCall(BuildContext context) async {
    try {
      bool isConnect = await connectionService.checkConnect();
      await _processRollCallSave(context, isOnline: isConnect);
    } catch (e) {
      AppMessage.errorMessage(
          context, AppLocalizations.of(context).translate("error_data"));
    }
  }

  // Main function to handle both online and offline saves
  Future<void> _processRollCallSave(BuildContext context,
      {required bool isOnline}) async {
    final studentProvider =
        Provider.of<ListStudentProvider>(context, listen: false);

    bool? youSure = await _showConfirmationDialog(
      context,
      title: isOnline
          ? AppLocalizations.of(context).translate("rollcall_check_save")
          : AppLocalizations.of(context).translate("rollcall_check_save_local"),
    );

    if (youSure != true) return;

    //
    QuickAlert.show(
        context: context, type: QuickAlertType.loading, disableBackBtn: true);
    List<MyStudent> studentsToCheck =
        List<MyStudent>.from(studentProvider.lstUpdateIsCheck);
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
        int index = studentProvider.lstUpdateIsCheck
            .indexWhere((student) => student.id == std.id);
        studentProvider.deleteFromLstUpdate(index);
        studentProvider.updateSavedRollCall(std);
        // await RollCallDatabaseRepository().deleteItem(std.id!);
      }
    }
    Navigator.pop(context);
    //

    await messageHandler.handleAction(
        context,
        () async => isAllSuccessful,
        AppLocalizations.of(context).translate("success_save"),
        AppLocalizations.of(context).translate("error_retry_failed"));
  }

  // Helper function to show confirmation dialog
  Future<bool?> _showConfirmationDialog(BuildContext context,
      {required String title}) async {
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
  Future<bool> _saveRollCallWithRetry(MyStudent std,
      {required int retryLimit, required bool isOnline}) async {
    int retryCount = 0;
    bool isSaved = false;

    while (!isSaved && retryCount < retryLimit) {
      if (isOnline) {
        isSaved = await rollCallApi.rollCall(std.id!, std.isCheck ?? "1");
      }
      if (!isSaved) {
        retryCount++;
      }
      await Future.delayed(const Duration(seconds: 1));
    }

    return isSaved;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Dịch vụ vị trí bị tắt.");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Quyền vị trí bị từ chối.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Quyền vị trí bị từ chối vĩnh viễn.");
    }

    Position position = await Geolocator.getCurrentPosition();
    print(
        "📍 Vị trí hiện tại: Lat: ${position.latitude}, Lng: ${position.longitude}");
    return position;
  }

  Future<Map<String, dynamic>> _fetchWeatherData() async {
    try {
      Position position = await _determinePosition();
      print(
          "🌍 Lấy dữ liệu thời tiết tại: ${position.latitude}, ${position.longitude}");

      String apiKey = "62c8370f658f2457db00ee12eaa5b07d"; // API Key của bạn
      String url =
          "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric&lang=vi";
      print("🔗 API URL: $url"); // Kiểm tra URL API

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("✅ Dữ liệu thời tiết: $data");
        return {
          "city": data["name"],
          "description": data["weather"][0]["description"],
          "temperature": data["main"]["temp"],
          "icon": data["weather"][0]["icon"],
        };
      } else {
        throw Exception("Lỗi khi tải dữ liệu thời tiết.");
      }
    } catch (e) {
      print("❌ Lỗi lấy dữ liệu thời tiết: $e");
      return {};
    }
  }

  Future<bool> isNearFacility(BuildContext context) async {
    try {
      const double proximityThreshold = 50; // 1km
      await listFacility.setList();
      List<MyFacility> lstFacility = listFacility.lstFacility!;
      List<MyFacility> nearbyFacility = [];

      print(
          "📍 Vị trí hiện tại: ${currentUser.latitude}, ${currentUser.longitude}");
      print("🏢 Danh sách cơ sở có trong hệ thống:");

      for (var facility in lstFacility) {
        double distance = Geolocator.distanceBetween(
          currentUser.latitude ?? 0.0, // Tránh lỗi nếu giá trị null
          currentUser.longitude ?? 0.0,
          facility.latitude ?? 0.0,
          facility.longtitude ?? 0.0,
        );

        print("🏢 Cơ sở: ${facility.name}");
        print("📍 Vị trí cơ sở: ${facility.latitude}, ${facility.longtitude}");
        print("📏 Khoảng cách: $distance mét");

        if (distance <= proximityThreshold) {
          nearbyFacility.add(facility);
        }
      }

      if (nearbyFacility.isNotEmpty) {
        currentFacility.setCurrent(nearbyFacility.first);
        print("✅ Tìm thấy cơ sở gần nhất: ${nearbyFacility.first.name}");
      } else {
        print("❌ Không có cơ sở nào trong phạm vi $proximityThreshold mét.");
      }

      return nearbyFacility.isNotEmpty;
    } catch (e) {
      print("❌ Lỗi trong quá trình kiểm tra khoảng cách: $e");
      return false;
    }
  }

  Future<void> rollCallCoachs(BuildContext context) async {
    await listFacility.setList();
    List<MyFacility> lstFacility = listFacility.lstFacility!;

    print("📌 Danh sách cơ sở từ database:");
    for (var facility in lstFacility) {
      print(
          "🏢 Cơ sở: ${facility.name}, Tọa độ: ${facility.latitude}, ${facility.longtitude}");
    }

    if (lstFacility.isEmpty) {
      print("⚠️ Lỗi: Không có cơ sở nào được tải từ database!");
    }
    try {
      await getCurrentPosition();
      bool isAtWork = await isNearFacility(context);

      print("🛠 Kiểm tra vị trí chấm công: $isAtWork");

      if (isAtWork) {
        print("✅ Bạn đang ở trong khu vực chấm công.");

        await messageHandler.handleAction(context, () async {
          await rollCallCoachesApi.rollCallCoachs(context);
          return true;
        }, "rollcall_success", "error_rollcall");
      } else {
        print("❌ Bạn không ở trong khu vực chấm công!");
        AppMessage.errorMessage(
            context, "Bạn chưa ở đúng vị trí để chấm công.");
      }
    } catch (e) {
      print("❌ Lỗi trong quá trình chấm công: $e");
      AppMessage.errorMessage(context, "Lỗi chấm công. Vui lòng thử lại.");
    }
  }

  Future<void> getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      currentUser.latitude = position.latitude; // Lưu dưới dạng double
      currentUser.longitude = position.longitude;
      print(
          "📌 Tọa độ hiện tại cập nhật: ${currentUser.latitude}, ${currentUser.longitude}");
    } catch (e) {
      print("❌ Lỗi khi lấy vị trí: $e");
    }
  }

  Future<void> handleAction(
      BuildContext context,
      Future<bool> Function(BuildContext) action, // Hàm có tham số `context`
      String successMessage,
      String errorMessage) async {
    try {
      bool result = await action(context); // Gọi hàm với `context`
      if (result) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: successMessage,
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: errorMessage,
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: errorMessage,
      );
    }
  }
}
