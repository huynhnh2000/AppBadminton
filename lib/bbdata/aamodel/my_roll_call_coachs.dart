class MyRollCallCoachs{
  String? id, coachId, statusId, isCheck, userCreated, userUpdate, dateCreated, dateUpdate;
  MyRollCallCoachs({
    this.id,
    this.coachId,
    this.statusId,
    this.isCheck,
    this.userCreated,
    this.userUpdate,
    this.dateCreated,
    this.dateUpdate
  });

  MyRollCallCoachs.fromJson(Map<dynamic, dynamic> e){
    id = e["rollCallCoachId"].toString();
    coachId = e["coachId"].toString();
    statusId = e["statusId"].toString();
    isCheck = e["isCheck"].toString();
    userCreated = e["userCreated"].toString();
    userUpdate = e["userUpdated"].toString();
    dateCreated = e["dateCreated"].toString();
    dateUpdate = e["dateUpdated"].toString();
  }
}