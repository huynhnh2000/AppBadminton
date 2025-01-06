class MyTuitions {
  String? id, studentId, isCheck, isNull, money, userCreated, userUpdated, dateCreated, dateUpdated;
  MyTuitions({
    this.id,
    this.studentId,
    this.isCheck,
    this.isNull,
    this.money,
    this.userCreated,
    this.userUpdated,
    this.dateCreated,
    this.dateUpdated
  });

  MyTuitions.fromJson(Map<dynamic, dynamic> e){
    id = e['tuitionId'].toString();
    studentId = e['studentId'].toString();
    isCheck = e['isCheck'].toString();
    isNull = e['isNull'].toString();
    money = e['money'].toString();
    userCreated = e['userCreated'].toString();
    userUpdated = e['userUpdated'].toString();
    dateCreated = e['dateCreated'].toString();
    dateUpdated = e['dateUpdated'].toString();
  }
}