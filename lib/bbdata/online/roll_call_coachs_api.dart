import 'dart:convert';
import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_roll_call_coachs.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RollCallCoachesApi{
  
  final String baseUrl = "${dotenv.env["BASE_URL"]}";
  final currentUser = MyCurrentUser();
  List<MyRollCallCoachs> lst = [];

  Future<List<MyRollCallCoachs>> getListByCoachId(String id) async{
    try{
      final res = await http.get(
        Uri.parse("$baseUrl/${dotenv.env["ROLLCALLCOACH_URL"]}/$id/getHistory"),
        headers: {"Authorization": 'Bearer ${currentUser.key}', "Content-Type": "application/json"}
      ).timeout(const Duration(seconds: 30));

      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        for(var i in data){
          lst.add(MyRollCallCoachs.fromJson(i));
        }
        return lst;
      }
      return [];
    }
    catch(e){
      log("$e");
      return [];
    }
  }

  Future<bool> checkByCoachsID(String id) async{
    lst = await getListByCoachId(id);
    String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());

    MyRollCallCoachs rollCallCoachs = MyRollCallCoachs();
    for(var rollcall in lst){
      if(rollcall.dateUpdate!.split("T")[0]==dateNow && rollcall.coachId==currentUser.id){
        rollCallCoachs = rollcall;
      }
    }
    return rollCallCoachs.id!=null;
  }

  Future<bool> rollCallCoachs() async{
    try{

      final body = {
        "coachId": int.parse(currentUser.id!),
        "statusId": 0,
        "isCheck": 1,
        "userCreated": currentUser.username,
        "userUpdated": currentUser.username,
        "dateCreated": DateTime.now().toLocal().toIso8601String(),
        "dateUpdated": DateTime.now().toLocal().toIso8601String()
      };

      final res = await http.post(
        Uri.parse("$baseUrl/${dotenv.env["ROLLCALLCOACH_URL"]}"),
        headers: {"Authorization": "Bearer ${currentUser.key}", "Content-Type": "application/json"},
        body: jsonEncode(body)
      ).timeout(const Duration(seconds: 30));

      return res.statusCode==201;
    }
    catch(e){
      log("$e");
      return false;
    }
  }
}