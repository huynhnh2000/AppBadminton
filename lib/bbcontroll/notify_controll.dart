// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:badminton_management_1/app_local.dart';
import 'package:badminton_management_1/bbcontroll/rollcall_controll.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/online/roll_call_coachs_api.dart';
import 'package:badminton_management_1/ccui/ccresource/app_resources.dart';
import 'package:flutter/material.dart';

class NotifyControll {
  final RollCallCoachesApi rollCallCoachesApi = RollCallCoachesApi();
  final RollCallControll rollCallControll = RollCallControll();
  final currentUser = MyCurrentUser();

//   Future<void> checkRollCallCoachs(BuildContext context) async {
//     try {
//       bool isRollCall =
//           await rollCallCoachesApi.checkByCoachsID(currentUser.id!);

//       // Hiển thị dialog thông báo
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(
//               isRollCall
//                   ? AppLocalizations.of(context).translate("rollcall_success")
//                   : AppLocalizations.of(context).translate("rollcall_fail"),
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             // content: Text(
//             //   isRollCall
//             //       ? "Bạn đã chấm công thành công!"
//             //       : "Bạn chưa chấm công. Hãy chấm công ngay!",
//             //   style: TextStyle(fontSize: 16),
//             // ),
//             actions: [
//               if (!isRollCall) // Nếu chưa chấm công, hiển thị nút chấm công
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Đóng hộp thoại
//                   },
//                   child: const Text("OK"),
//                 ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       log("❌ Lỗi kiểm tra chấm công: $e");
//     }
//   }
// }
  Future<void> checkRollCallCoachs(BuildContext context) async {
    try {
      bool isRollCall =
          await rollCallCoachesApi.checkByCoachsID(currentUser.id!);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              isRollCall
                  ? AppLocalizations.of(context)
                      .translate("rollcall_success") // Đã điểm danh
                  : AppLocalizations.of(context)
                      .translate("rollcall_fail"), // Chưa điểm danh
              style: AppTextstyle.mainTitleStyle,
            ),
            content: Text(
              isRollCall
                  ? "Bạn đã chấm công hôm nay!" // Nếu đã điểm danh
                  : "Bạn chưa chấm công. Hãy chấm công ngay!", // Nếu chưa điểm danh
              style: const TextStyle(fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng hộp thoại
                },
                child: const Text(
                  "Hủy",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              if (!isRollCall) // Nếu chưa điểm danh, thêm nút "Chấm công ngay"
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context); // Đóng hộp thoại trước
                    await rollCallCoachesApi.rollCallCoachs(context);
                    // Gọi API điểm danh
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green, // Màu nền
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text(
                    "Chấm công ngay",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    } catch (e) {
      log("❌ Lỗi kiểm tra chấm công: $e");
    }
  }
}
