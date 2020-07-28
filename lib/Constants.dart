import 'package:device_id/device_id.dart';

final String BaseUrl = "http://user.brozapp.com/api/";

class Constants {
  static final String deviceToken =
      "d_yFWOIfg0t-jixOCLzgXi:APA91bHk8JUiwVxghrhWkdlieMRL1Dpp33WSKmy77LMgp9TO_OK5JMTRx5EfVDrzC2lYZr03cIcKdJ7PHxmrDbqmTXeVbZR6dRFberz_7D4QopP8cSfLZ31SLAXnDSWRZjcrPB0P_Gx6";
  static String deviceId = DeviceId.getID as String;
}
