
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:badminton_management_1/bbcontroll/hash/hash_password.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserApi{

  final String baseUrl = "${dotenv.env["BASE_URL"]}";
  final currentUser = MyCurrentUser();

  Future<bool> checkLoginCoach({phone, password}) async{
    try{
      String hashPass = hashPassword(password.replaceAll(" ", ""));

      final body = {
        "phone": phone.replaceAll(" ", ""),
        "password": hashPass
      };

      final res = await http.post(
        Uri.parse("$baseUrl/${dotenv.env["USER_URL"]}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
      ).timeout(const Duration(seconds: 30));

      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        currentUser.key = data["token"];
        bool isGetCurrent = await getCurrentUserCoach(phone);
        return isGetCurrent;
      }
      else{return false;}
    }
    catch(e){
      log("$e");
      return false;
    }
  }

  Future<bool> checkLoginStudent({code, password}) async{
    try{
      String hashPass = hashPassword(password);

      final body = {
        "studentCode": code,
        "password": hashPass
      };

      final res = await http.post(
        Uri.parse("$baseUrl/${dotenv.env["USER_URL"]}/student"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
      ).timeout(const Duration(seconds: 30));

      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        currentUser.key = data["token"];
        bool isGetCurrent = await getCurrentUserStudent(code);
        return isGetCurrent;
      }
      else{return false;}
    }
    catch(e){
      log("$e");
      return false;
    }
  }

  Future<bool> getCurrentUserCoach(String phone) async{
    try{

      final res = await http.get(
        Uri.parse("$baseUrl/${dotenv.env["COACHS_URL"]}/phone/$phone"),
        headers: {"Authorization": "Bearer ${currentUser.key}", "Content-Type": "application/json"}
      ).timeout(const Duration(seconds: 30));

      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        if(data["statusId"].toString()=="0"){
          MyUser user = MyUser.fromJson(data);
          currentUser.setCurrent(user);
          return currentUser.username!=null;
        }
        return false;
      }
      return false;
    }
    catch(e){
      log("$e");
      return false;
    }
  }

  Future<bool> getCurrentUserStudent(String input) async{
    try{
      final res = await http.get(
        Uri.parse("$baseUrl/${dotenv.env["STUDENT_URL"]}/input/$input"),
        headers: {"Authorization": "Bearer ${currentUser.key}", "Content-Type": "application/json"}
      ).timeout(const Duration(seconds: 30));

      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        if(data["statusId"].toString()=="3"){
          MyUser user = MyUser.fromJson(data);
          currentUser.setCurrent(user);
          return currentUser.username!=null;
        }
        return false;
      }
      return false;
    }
    catch(e){
      log("$e");
      return false;
    }
  }

  Future<bool> isDomainValid(String email) async {
    final domain = email.split('@').last;
    try {
      final result = await InternetAddress.lookup(domain);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}