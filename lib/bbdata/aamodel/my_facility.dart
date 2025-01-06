import 'package:badminton_management_1/bbdata/online/facility_api.dart';

class MyFacility{
  String? id, name, longtitude, latitude;
  MyFacility({
    this.id,
    this.name,
    this.latitude,
    this.longtitude
  }); 

  MyFacility.fromJson(Map<dynamic, dynamic> e){
    id = e["facilityId"].toString();
    name = e["facilityName"].toString();
    latitude = e["latitude"].toString();
    longtitude = e["longtitude"].toString();
  }
}

class MyCurrentFacility extends MyFacility{
  MyCurrentFacility._privateContructor();
  static final MyCurrentFacility _instance = MyCurrentFacility._privateContructor();
  factory MyCurrentFacility(){
    return _instance;
  }

  void setCurrent(MyFacility facility){
    id = facility.id;
    name = facility.name;
    latitude = facility.latitude;
    longtitude = facility.longtitude;
  }
}

class MyListCurrentFacility{
  MyListCurrentFacility._privateContructor();
  static final MyListCurrentFacility _instance = MyListCurrentFacility._privateContructor();
  factory MyListCurrentFacility(){
    return _instance;
  }

  List<MyFacility>? lstFacility;

  Future<void> setList() async{
    if(lstFacility==null || lstFacility!.isEmpty){
      lstFacility = await FacilityApi().getList();
    }
  }
}