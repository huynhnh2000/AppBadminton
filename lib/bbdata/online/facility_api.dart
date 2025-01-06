import 'dart:convert';
import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_facility.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FacilityApi{
  final String baseUrl = "${dotenv.env["BASE_URL"]}";
  final currentUser = MyCurrentUser();

  Future<List<MyFacility>> getList() async{
    try{
      final res = await http.get(
        Uri.parse("$baseUrl/${dotenv.env["FACILITY_URL"]}"),
        headers: {"Authorization": "Bearer ${currentUser.key}", "Content-Type": "application/json"}
      ).timeout(const Duration(seconds: 30));
      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        List<MyFacility> lst = [];
        for(var fac in data){
          lst.add(MyFacility.fromJson(fac));
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