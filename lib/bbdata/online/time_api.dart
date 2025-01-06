import 'dart:convert';
import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_time.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TimeApi{

  final String baseUrl = "${dotenv.env["BASE_URL"]}";
  final currentUser = MyCurrentUser();

  Future<List<MyTime>> getList() async{
    try{
      final res = await http.get(
        Uri.parse("$baseUrl/${dotenv.env["LEARNINGSCHEDULE_URL"]}"),
        headers: {"Authorization": "Bearer ${currentUser.key}"}
      ).timeout(const Duration(seconds: 30));

      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        List<MyTime> lst = [];
        for(var time in data){
          lst.add(MyTime.fromJson(time));
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