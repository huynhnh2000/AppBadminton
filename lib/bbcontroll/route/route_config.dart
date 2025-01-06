import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/ccui/abmain/coach/home_coach_view.dart';
import 'package:badminton_management_1/ccui/abmain/student/home_student_view.dart';
import 'package:badminton_management_1/ccui/ccauth/signin/signin_coach_view.dart';
import 'package:badminton_management_1/ccui/ccauth/signin/signin_student_view.dart';
import 'package:badminton_management_1/ccui/ccuser/rollcall_view/rollcall_coach_view.dart';
import 'package:badminton_management_1/ccui/ccuser/rollcall_view/rollcall_student_view.dart';
import 'package:flutter/material.dart';

class RouteConfig {
  final String route;
  final Widget Function() builder;

  RouteConfig(this.route, this.builder);
}

class UserRoutes {

  static MyCurrentUser currentUser = MyCurrentUser();
  
  static List<RouteConfig> getRoutesForCoach() {
    return [
      RouteConfig("/signin", () => SignInCoachView()),
      RouteConfig("/home", () => const HomeCoachView()),
      RouteConfig("/history/rollcall", () => RollCallCoachHistoryView(coachId: currentUser.id??"",)),
      // Add more routes here for Coach
    ];
  }

  static List<RouteConfig> getRoutesForStudent() {
    return [
      RouteConfig("/signin", () => SignInStudentView()),
      RouteConfig("/home", () => const HomeStudentView()),
      RouteConfig("/history/rollcall", () => const RollCallStudentHistoryView()),
      // Add more routes here for Student
    ];
  }

}