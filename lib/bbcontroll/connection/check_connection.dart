import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService{

  Stream<List<ConnectivityResult>> get onConnectivityChanged => (Connectivity().onConnectivityChanged);

  Future<bool> checkConnect() async{
    List<ConnectivityResult> connectResult = await (Connectivity().checkConnectivity());
    return connectResult.contains(ConnectivityResult.mobile) || connectResult.contains(ConnectivityResult.wifi);
  }

}