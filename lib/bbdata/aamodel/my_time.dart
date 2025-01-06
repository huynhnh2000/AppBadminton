class MyTime{
  String? id, name;
  MyTime({
    this.id,
    this.name
  });

  MyTime.fromJson(Map<dynamic, dynamic> e){
    id = e["timeId"].toString();
    name = e["timeName"].toString();
  }

  Map<String, dynamic> toMapSqlite(){
    return {
      "timeId": id,
      "timeName": name
    };
  }
}