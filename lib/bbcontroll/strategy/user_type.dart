
// ignore_for_file: use_build_context_synchronously

import 'package:badminton_management_1/bbcontroll/strategy/user_student_type.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_coach.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_student.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/online/coach_api.dart';
import 'package:badminton_management_1/bbdata/online/student_api.dart';
import 'package:badminton_management_1/bbdata/online/user_api.dart';
import 'package:flutter/material.dart';

final UserApi userApi = UserApi();
final currentUser = MyCurrentUser();

//---
class UserTypeContext{
  //singleton
  UserTypeContext._privateContructor();
  static final UserTypeContext _instance = UserTypeContext._privateContructor();
  factory UserTypeContext(){
    return _instance;
  }
  //
  
  static UserTypeStrategy? strategy;

  static Future<bool> login(MyUser user) async{
    if (strategy != null) {
      bool isLogin = await strategy!.login(user);
      return isLogin;
    } else {
      throw Exception("UserTypeStrategy is not set.");
    }
  }

  static Future<bool> checkDublicatePhone(String phone) async {
    if (strategy != null) {
      bool isDuplicate = false;
      if (strategy is StudentStrategy) {
        MyStudent student = await StudentApi().getStudentByPhone(phone);
        // Check if student phone is neither null nor empty
        isDuplicate = student.phone != null && student.phone != "";
      } else {
        MyCoach coach = await CoachApi().getCoachByPhone(phone);
        // Check if coach phone is neither null nor empty
        isDuplicate = coach.phone != null && coach.phone != "";
      }
      return isDuplicate;
    } else {
      throw Exception("UserTypeStrategy is not set.");
    }
  }

  static Future<bool> checkDublicateEmail(String email) async {
    if (strategy != null) {
      bool isDuplicate = false;
      if (strategy is StudentStrategy) {
        MyStudent student = await StudentApi().getStudentByEmail(email);
        isDuplicate = student.email != null && student.email != "";
      } else {
        MyCoach coach = await CoachApi().getCoachByEmail(email);
        // Check if coach email is neither null nor empty
        isDuplicate = coach.email != null && coach.email != "";
      }
      return isDuplicate;
    } else {
      throw Exception("UserTypeStrategy is not set.");
    }
  }

  static void navigateReplacement(BuildContext context, String route) {
    if (strategy != null) {
      strategy!.navigatePageRouteReplacement(context, route);
    } else {
      throw Exception("UserTypeStrategy is not set.");
    }
  }

  static void navigate(BuildContext context, String route) {
    if (strategy != null) {
      strategy!.navigatePageRoute(context, route);
    } else {
      throw Exception("UserTypeStrategy is not set.");
    }
  }

  static Future<bool> updateBirthDay(BuildContext context, String birthday) async{
    if(strategy != null){
      bool isUpdate = await strategy!.updateBirthDay(context, birthday);
      return isUpdate;
    }
    else{
      throw Exception("UserTypeStrategy is not set.");
    }
  }

  static Future<bool> updatePassword(BuildContext context, String password) async{
    if(strategy != null){
      bool isUpdate = await strategy!.updatePassword(context, password);
      return isUpdate;
    }
    else{
      throw Exception("UserTypeStrategy is not set.");
    }
  }

  static Future<bool> updatePhone(BuildContext context, String phone) async{
    if(strategy != null){
      bool isUpdate = await strategy!.updatePhone(context, phone);
      return isUpdate;
    }
    else{
      throw Exception("UserTypeStrategy is not set.");
    }
  }

  static Future<bool> updateEmail(BuildContext context, String email) async{
    if(strategy != null){
      bool isUpdate = await strategy!.updateEmail(context, email);
      return isUpdate;
    }
    else{
      throw Exception("UserTypeStrategy is not set.");
    }
  }
}

//---
abstract class UserTypeStrategy{

  Future<bool> login(MyUser user);

  Future<bool> updateBirthDay(BuildContext context, String birthday);
  Future<bool> updatePassword(BuildContext context, String password);
  Future<bool> updatePhone(BuildContext context, String phone);
  Future<bool> updateEmail(BuildContext context, String email);

  void navigatePageRouteReplacement(BuildContext context, String route);
  void navigatePageRoute(BuildContext context, String route);
}

