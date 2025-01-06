class MyRollCall {
  String? studentId, coachId, isCheck, statusId, userCreated, userUpdated, dateCreated, dateUpdated;

  MyRollCall({
    this.studentId,
    this.coachId,
    this.isCheck,
    this.statusId,
    this.userCreated,
    this.userUpdated,
    this.dateCreated,
    this.dateUpdated,
  });

  MyRollCall.fromJson(Map<String, dynamic> e) {
    studentId = e['studentId'].toString();
    coachId = e['coachId'].toString();
    isCheck = e['isCheck'].toString();
    statusId = e['statusId'].toString();
    userCreated = e['userCreated'].toString();
    userUpdated = e['userUpdated'].toString();
    dateCreated = e['dateCreated'].toString();
    dateUpdated = e['dateUpdated'].toString();
  }

   Map<String, dynamic> toMapSqlite() {
    return {
      "studentId": studentId,
      "isCheck": isCheck,
      "coachId": coachId,
      "statusId": statusId,
      "userCreated": userCreated,
      "userUpdated": userUpdated,
      "dateCreated": dateCreated,
      "dateUpdated": dateUpdated,
    };
  }

}