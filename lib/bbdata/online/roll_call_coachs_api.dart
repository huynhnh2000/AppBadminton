import 'dart:convert';
import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_roll_call_coachs.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RollCallCoachesApi {
  final String baseUrl = "${dotenv.env["BASE_URL"]}";
  final currentUser = MyCurrentUser();
  List<MyRollCallCoachs> lst = [];

  Future<List<MyRollCallCoachs>> getListByCoachId(String id) async {
    try {
      final res = await http.get(
          Uri.parse(
              "$baseUrl/${dotenv.env["ROLLCALLCOACH_URL"]}/$id/getHistory"),
          headers: {
            "Authorization": 'Bearer ${currentUser.key}',
            "Content-Type": "application/json"
          }).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        for (var i in data) {
          lst.add(MyRollCallCoachs.fromJson(i));
        }
        return lst;
      }
      return [];
    } catch (e) {
      log("$e");
      return [];
    }
  }

  Future<bool> checkByCoachsID(String id) async {
    lst = await getListByCoachId(id);
    String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());

    MyRollCallCoachs rollCallCoachs = MyRollCallCoachs();
    for (var rollcall in lst) {
      if (rollcall.dateUpdate!.split("T")[0] == dateNow &&
          rollcall.coachId == currentUser.id) {
        rollCallCoachs = rollcall;
      }
    }
    return rollCallCoachs.id != null;
    // lst = await getListByCoachId(id);

    // // ❌ Bỏ qua kiểm tra ngày, chỉ kiểm tra nếu có bất kỳ bản ghi nào của HLV
    // return lst.isNotEmpty;
  }

  Future<int> getRollCallCountToday(String id) async {
    lst = await getListByCoachId(id);
    String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());

    int count = lst
        .where((rollcall) => rollcall.dateUpdate!.split("T")[0] == dateNow)
        .length;

    return count; // Trả về số lần điểm danh trong ngày
  }

  // Future<bool> rollCallCoachs() async {
  //   try {
  //     final body = {
  //       "coachId": int.parse(currentUser.id!),
  //       "statusId": 0,
  //       "isCheck": 1,
  //       "userCreated": currentUser.username,
  //       "userUpdated": currentUser.username,
  //       "dateCreated": DateTime.now().toLocal().toIso8601String(),
  //       "dateUpdated": DateTime.now().toLocal().toIso8601String()
  //     };

  //     final res = await http
  //         .post(Uri.parse("$baseUrl/${dotenv.env["ROLLCALLCOACH_URL"]}"),
  //             headers: {
  //               "Authorization": "Bearer ${currentUser.key}",
  //               "Content-Type": "application/json"
  //             },
  //             body: jsonEncode(body))
  //         .timeout(const Duration(seconds: 30));

  //     return res.statusCode == 201;
  //   } catch (e) {
  //     log("$e");
  //     return false;
  //   }
  // }
  Future<bool> rollCallCoachs(BuildContext context) async {
    try {
      int count = await getRollCallCountToday(currentUser.id!);

      if (count > 0) {
        // Nếu đã điểm danh ít nhất 1 lần, hiển thị thông báo xác nhận
        bool? confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Xác nhận điểm danh",
                style: const TextStyle(
                    fontSize: 25, color: Color.fromARGB(255, 13, 71, 161)),
              ),
              content: Text(
                "Bạn đã điểm danh $count lần hôm nay. Bạn có muốn tiếp tục không?",
                style: const TextStyle(fontSize: 20),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Hủy
                  child: const Text(
                    "Hủy",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Xác nhận
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green, // Màu nền
                    padding: const EdgeInsets.all(10),
                  ), // Padding = 10
                  child: const Text(
                    "Xác nhận",
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

        if (confirm == null || !confirm)
          return false; // Nếu hủy, không tiếp tục
      }

      // Tiến hành điểm danh
      final body = {
        "coachId": int.parse(currentUser.id!),
        "statusId": 0,
        "isCheck": 1,
        "userCreated": currentUser.username,
        "userUpdated": currentUser.username,
        "dateCreated": DateTime.now().toLocal().toIso8601String(),
        "dateUpdated": DateTime.now().toLocal().toIso8601String()
      };

      final res = await http
          .post(
            Uri.parse("$baseUrl/${dotenv.env["ROLLCALLCOACH_URL"]}"),
            headers: {
              "Authorization": "Bearer ${currentUser.key}",
              "Content-Type": "application/json"
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 201) {
        count++;
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Điểm danh thành công!",
          text: "Bạn đã điểm danh $count lần trong ngày.",
        );
        return true;
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Lỗi điểm danh",
          text: "Vui lòng thử lại sau!",
        );
        return false;
      }
    } catch (e) {
      log("$e");
      return false;
    }
  }
}
