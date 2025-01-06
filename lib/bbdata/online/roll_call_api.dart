import 'dart:convert';
import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_roll_call.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RollCallApi{
  final String baseUrl = "${dotenv.env["BASE_URL"]}";
  final currentUser = MyCurrentUser();
  
  Future<List<MyRollCall>> getListDate() async{
    try{
      DateFormat formated = DateFormat("yyyy-MM-dd");
      String dateNow = formated.format(DateTime.now());

      final res = await http.get(
        Uri.parse("$baseUrl/${dotenv.env["ROLLCALL_URL"]}/date/$dateNow"),
        headers: {"Authorization": "Bearer ${currentUser.key}", "Content-Type": "application/json"}
      ).timeout(const Duration(seconds: 30));

      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        List<MyRollCall> lst = [];
        for(var rc in data){
          lst.add(MyRollCall.fromJson(rc));
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

  Future<bool> rollCall(String studentId, String isCheck) async{
    try{
      int id = int.parse(studentId);
      bool check = isCheck=="1";

      final res = await http.post(
        Uri.parse("$baseUrl/${dotenv.env["ROLLCALL_URL"]}?studentId=$id&isPresent=$check&status=true"),
        headers: {"Authorization": "Bearer ${currentUser.key}", "Content-Type": "application/json"}
      ).timeout(const Duration(seconds: 30));

      return res.statusCode==200;
    }
    catch(e){
      log("$e");
      return false;
    }
  }

  Future<List<MyRollCall>> getListStudentId(String studentId) async{
    try{
      
      final res = await http.get(
        Uri.parse("$baseUrl/${dotenv.env["ROLLCALL_URL"]}/student/${int.parse(studentId)}/attendance-history"),
        headers: {"Authorization": "Bearer ${currentUser.key}", "Content-Type": "application/json"}
      ).timeout(const Duration(seconds: 30));

      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        List<MyRollCall> lst = [];
        for(var rc in data){
          lst.add(MyRollCall.fromJson(rc));
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

}