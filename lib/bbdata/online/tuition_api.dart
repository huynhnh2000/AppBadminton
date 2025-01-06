import 'dart:convert';
import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_tuitions.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TuitionApi{

  final String baseUrl = "${dotenv.env["BASE_URL"]}";
  final currentUser = MyCurrentUser();

  Future<List<MyTuitions>> getList() async{
    try{
      final res = await http.get(
        Uri.parse("$baseUrl/${dotenv.env["TUITION_URL"]}/studentId/${int.parse(currentUser.id??"")}"),
        headers: {"Authorization": "Bearer ${currentUser.key}"}
      );

      List<MyTuitions> lst = [];
      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        for(var tuition in data){
          lst.add(MyTuitions.fromJson(tuition));
        }
      }
      return lst;
    }
    catch(e){
      log("$e");
      return [];
    }
  }

}