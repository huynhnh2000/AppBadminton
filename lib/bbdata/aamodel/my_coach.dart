class MyCoach {
  String? id,
      email,
      password,
      coachName,
      lessonPlan,
      image,
      gender,
      phone,
      birthday,
      startDay;
  String? code, tuitions, userTypeId;
  String? imageAssets;
  String? isCheck, statusId;

  MyCoach(
      {this.id,
      this.email,
      this.password,
      this.coachName,
      this.lessonPlan,
      this.image,
      this.gender,
      this.imageAssets,
      this.phone,
      this.birthday,
      this.startDay,
      this.code,
      this.tuitions,
      this.userTypeId,
      this.isCheck,
      this.statusId});

  MyCoach.fromJson(Map<dynamic, dynamic> e) {
    id = e["coachId"].toString();
    email = e["email"].toString();
    password = e["password"].toString();
    coachName = e["coachName"].toString();
    lessonPlan = e["lessonPlan"].toString();
    image = e["images"].toString();
    gender = e["genderId"].toString();
    phone = e["phone"].toString();
    birthday = e["birthday"].toString();
    startDay = e["workingStart"].toString();
    code = e["studentCode"].toString();
    tuitions = e["tuitions"] != null ? e["tuitions"].toString() : "";
    userTypeId = e["typeUserId"] != null ? e["typeUserId"].toString() : "";
    statusId = e["statusId"].toString();
  }
}
