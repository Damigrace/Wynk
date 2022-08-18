import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:infobip_rtc/api/listeners.dart';
import 'package:infobip_rtc/infobip_rtc.dart';
import 'package:infobip_rtc/model/events.dart';
import 'package:infobip_rtc/model/requests.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/login_feature/login_page.dart';
import 'package:untitled/features/verification_feature/confirm_transaction_pin.dart';
import 'package:untitled/main.dart';
import 'package:untitled/utilities/constants/colors.dart';
import 'controllers.dart';
import 'utilities/models/data_confirmation.dart';
import 'features/registration_feature/register_page.dart';
import 'features/registration_feature/sign_up_personal_details.dart';
  String wynkBaseUrl='https://wynk.ng/stagging-api';

  showSnackBar(BuildContext context, String msg){
    final snackBar = SnackBar(
      backgroundColor: kBlueTint,
      content:  Text(msg,style: TextStyle(color: Colors.white),),
      action: SnackBarAction(
        textColor: kYellow,
        label:  'Dismiss',onPressed: (){},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

showToast( String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: kBlueTint,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

  Future<Map<String, dynamic>> postRequest({required String? IDType, required String? IDNum,required String? WynkId}) async {
    print(IDType);
    var url = await Uri.parse ('https://wynk.ng/stagging-api/authenticate-verifyme');
    var body = json.encode({
      "verification_type": "$IDType",
      "verification_number": "$IDNum",
      "wynkid": "$WynkId"
    });
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print(dataBody);
    return dataBody;
  }
Future<Map<String, dynamic>> postRequest2({
  required String? FirstName, required String? LastName,
  required String? WynkId, String? email,String? referralCode,String? address}) async {
  var url = await Uri.parse ('https://wynk.ng/stagging-api/registeration-process');
  print('$WynkId,$FirstName,$LastName');
  var body = json.encode({
    // "email": email,
    // "referral_code": referralCode,
    // "address": address,
    "wynkid": "$WynkId",
    "firstname":FirstName,
    "lastname":LastName
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody2= json.decode(response.body);
  print('$dataBody2,1');
  return dataBody2;
}

Future<Map<String, dynamic>> postRequest3({
  required String? WynkId}) async {
  var url = await Uri.parse ('https://wynk.ng/stagging-api/view-user-details-verifyme');
  print('$WynkId');
  var body = json.encode({
    "wynkid": "$WynkId"
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody2= json.decode(response.body);
  print('$dataBody2,2');
  return dataBody2;
}

  String otpUrl='http://api.ebulksms.com:8080/sendsms.json';
String? userMobile;
Future getVerificationDetails(BuildContext context)async {
  String? uId=context.read<FirstData>().uniqueId;
  Map userData = await postRequest(WynkId: uId, IDNum: idNumController.text, IDType: context.read<FirstData>().UserSelectedId);
  if(userData['statusCode']=='User information not found in the database. Please check and try again.'){
    showSnackBar(context,'User information not found in the database. Please check and try again.');
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
  }
 else {
   await postRequest2(FirstName: firstNameController.text, LastName: lastNameController.text, WynkId:uId);
  Map userData3= await postRequest3(WynkId:uId);
  if(userData3["phone"]==null){
    context.read<FirstData>().checkUserRegStat(true);
  showToast('It seems you have a record with us.');
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const LoginPage()
  ));
  }
  confirmationPhoneCont.text=userData3["phone"];
  confirmationFirstnameCont.text=userData3['firstname'];
  confirmationLastnameCont.text=userData3['lastname'];
  confirmationDobCont.text=userData3['birthdate'];
  confirmationDocIDCont.text=idNumController.text;
  confirmationEmailCont.text=emailController.text;
  context.read<FirstData>().getUserImgUrl(userData3['passport']);
  print('post requesting completed');
  Navigator.pop(context);
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const DataConfirmation()
  ));
  print('navigating completed');
}}
Future<Map<String, dynamic>> sendUserMobileforOtp({required String userMobileNo}) async {
  var url = await Uri.parse ('$wynkBaseUrl/signup-otp');
  var body = json.encode({
    'phone': userMobileNo,
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print(dataBody);
  return dataBody;
}
Future<Map<String, dynamic>> sendLoginDetails({required String pin, String? numCode}) async {
  print('started');
  final prefs=await SharedPreferences.getInstance();

  var url = Uri.parse ('$wynkBaseUrl/login_process');
  print('${prefs.getString('Origwynkid')},$pin');
  var body = json.encode({
    'username':prefs.getString('Origwynkid'),
    'password': pin
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  var dataBody= json.decode(response.body);

  print(dataBody);
  return dataBody;
}

Future<Map<String, dynamic>> sendLoginDetails2({required String pin, String? numCode}) async {
  String userNum = '$numCode${userNumLogController.text}';
  String userNumber = userNum.substring(1);
print('$userNumber:$pin}');
  var url = Uri.parse ('$wynkBaseUrl/login_process');
  print('${userNumLogController.text},$pin');
  var body2 = json.encode({
    'username':userNumber,
    'password': pin
  });

  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body2,
  );
  print('started');
  var dataBody= json.decode(response.body);
  print('login process: $dataBody');
  return dataBody;
}
Future<Map<String, dynamic>> doOtpVerification({required String? otp,required String? uniqueId }) async {
  var url = await Uri.parse ('$wynkBaseUrl/validate-otp');
  print('$otp,this');
  print('$uniqueId,this');
  var body = json.encode({
    'otp': otp,
    'wynkid':uniqueId
  });

  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print(dataBody);
  return dataBody;
}

  Map otpGenBody = {
    "SMS": {
      "auth": {
        "username": "olumideogundele@gmail.com",
        "apikey": "b97826d6ae9b6356f3f803e3692b4d6122360ddb"
      },
      "message": {
        "sender": "Wynk",
        "messagetext": "Your Wynk registration One Time Password(OTP) is $otp. Please use it within 3 minutes.",
        "flash": "0"
      },
      "recipients":
      {
        "gsm": [
          {
            "msidn": "$userMobile",
            "msgid": "uniqueid1"
          },
        ]
      }
    }
  };
  Future<Map<String, dynamic>> getOtp(BuildContext context) async {
    userMobile=Provider.of<FirstData>(context,listen: false).userNumber;
    print(userMobile);
    var url = await Uri.parse(otpUrl);
    var body = json.encode(otpGenBody);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody = json.decode(response.body);
    print(dataBody);
    return dataBody;
  }
Future<Map<String, dynamic>> saveUserPin(BuildContext context) async {
    Position pos =  await determinePosition(context);
  var url = await Uri.parse('https://wynk.ng/stagging-api/set-pin');
  var body = json.encode({
    "long": pos.longitude,
    "lat": pos.latitude,
    "pin":confirmTPinController.text,
    "wynkid":context.read<FirstData>().uniqueId
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody = json.decode(response.body);
  print(dataBody);
  return dataBody;
}

Future<Map<String, dynamic>> getCapDetails(String? wynkid) async {
  var url = await Uri.parse('$wynkBaseUrl/get-captain-details');
  var body = json.encode({
    "wynkid":wynkid
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody = json.decode(response.body);
  print(' captain details: $dataBody');
  return dataBody;
}


Future<Map<String, dynamic>> getUserRegisteredDetails({required String wynkId}) async {
  var url = await Uri.parse ('$wynkBaseUrl/view-user-details-verifyme');
  var body = json.encode({
    'wynkid': wynkId
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  final prefs =await SharedPreferences.getInstance();
  print('$dataBody in this');
  await prefs.setString('firstname', dataBody['firstname']);
  return dataBody;

}
String destination = '';
Future<Map<String, dynamic>?> lookForCaptain({
  required LatLng pickupPos, required LatLng destPos, required String wynkid,required String? paymentMeans,required BuildContext context}) async {
  List <Placemark> pickup = await placemarkFromCoordinates(pickupPos.latitude,pickupPos.longitude);
  List <Placemark> destination = await placemarkFromCoordinates(destPos.latitude,destPos.longitude);
  context.read<FirstData>().savePatronPickupPlace(pickup[0].street!);
  context.read<FirstData>().savePatronDestPlace(destination[0].street!);

  var url = await Uri.parse ('$wynkBaseUrl/search-captain');
  var body = json.encode(
      {
        'payment_mode' : paymentMeans,
        'wynkid': wynkid,
        'loading_long':pickupPos.longitude,
        'loading_lat':pickupPos.latitude,
        'destination_long':destPos.longitude,
        'destination_lat':destPos.latitude,
  }
  );
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print('search-captain ${dataBody}');
    return dataBody;
  }
  catch(e){print(e);return null;}

}
Future<Map<String, dynamic>?> getNotification({ required String wynkid}) async {

  var url = await Uri.parse ('$wynkBaseUrl/get-notification');
  var body = json.encode(
      {
        'wynkid': wynkid,

      }
  );
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print('getNotifification: ${dataBody}');
    // if(dataBody.statusCode == 200){
    //   NotificationService.showNotif('Wynk', 'message');
    // }
    return dataBody;
  }
  catch(e){print(e);return null;}

}
Future<Map<String, dynamic>?> rideRating({required String wynikd, required String rideCode,required double star,required String comment}) async {
  print('ride finish: ${rideCode},${star},${comment}');
  var url = await Uri.parse ('$wynkBaseUrl/rating');
  var body = json.encode(
      {
        'wynk_id':wynikd,
        'ride_code': rideCode,
        'star':star,
        'comment':comment

      }
  );
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print('comment: ${dataBody}');

    return dataBody;
  }
  catch(e){print(e);return null;}

}
Future<Position> determinePosition(BuildContext context)async{
  bool? serviceEnabled;
  LocationPermission? permission;
  serviceEnabled= await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled){
    showSnackBar(context, 'Location services are disabled');
    await Geolocator.requestPermission();

    return Future.error('Location services are disabled');
  }
  permission=await Geolocator.checkPermission();
  if(permission==LocationPermission.denied){

    permission=await Geolocator.requestPermission();
    if(permission==LocationPermission.denied){
      showSnackBar(context, 'Location permission are denied');
      return Future.error('Location permission are denied');
    }
  }
  Position geoPos;
  try {
    geoPos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation,timeLimit: Duration(seconds: 5));
  } catch(e) {
    geoPos = await Geolocator.getLastKnownPosition()??Position(longitude: 5, latitude: 7, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  }
  return geoPos;

}
Future saveUserLocation({required String wynkId,required LatLng userCoordinates})async{
  var url = await Uri.parse ('$wynkBaseUrl/tracker');
  var body = json.encode({
    'wynkid': wynkId,
    'latitude':userCoordinates.latitude,
    'longitude':userCoordinates.longitude
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('saveuserlocation:$dataBody');
}
Future<Map<String, dynamic>> getAssociation()async{
  var url = await Uri.parse ('$wynkBaseUrl/get-association');
  var response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  var dataBody= json.decode(response.body);

  print(dataBody['message'][0]['name']);
  return dataBody;
}
Future<Map<String, dynamic>> getCArType()async{
  var url = await Uri.parse ('$wynkBaseUrl/get-car-type');
  var response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  var dataBody= json.decode(response.body);

  print(dataBody['message']);
  return dataBody;
}
Future<Map<String, dynamic>> getCarModel(int carId)async{
  var url = await Uri.parse ('$wynkBaseUrl/get-car-model');
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'car_type_id': "${carId + 1}"
      })
  );
  var dataBody= json.decode(response.body);

  print('get car model $dataBody');
  return dataBody;
}
Future<Map<String, dynamic>> onlineStatus(int status,LatLng location)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/captain-switch');
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "wynkid": prefs.getString('Origwynkid')!,
        "longitude": location.longitude,
        "latitude": location.latitude,
        "value":status
      })
  );
  var dataBody= json.decode(response.body);

  print('Online status: $dataBody');
  return dataBody;
}
Future<Map<String, dynamic>> captainFinalReg(
    String? captainType,
    String? brand,
    String? model,
    String? carColor,
    String? year,
    String? plateNumber,
    String? capacity,
    String? fullName,
    String? driverLicense,
    String? frontView,
    String? backView,
    String? inspection,
    String? vehicleLicense,
    String? vehicleRegistration,
    BuildContext context) async {
  print('asso type: $captainType');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse('$wynkBaseUrl/captain-complete');
  var body = json.encode({
    "driverlicence":driverLicense,
    "association": captainType,
    "brand": brand,
    "model": model,
    "car_color": carColor,
    "year": year,
    "plate_number": plateNumber,
    "capacity": capacity,
    "full_name": fullName,
    "frontview": frontView,
    "backview": backView,
    "inspection": inspection,
    "vehiclelicence": vehicleLicense,
    "vehicleregistration": vehicleRegistration,
    "wynkid":prefs.getString('Origwynkid')!,
  });
print('$captainType');
  //WYNK74832498
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  print(response.body);
  var dataBody = json.decode(response.body);
  print(dataBody);
  return dataBody;
}
Future<Map<String, dynamic>?> getRideDetails({ required String wynkid,required String code}) async {
  print('$wynkid,$code');
  var url = await Uri.parse ('$wynkBaseUrl/get-ride-details');
  var body = json.encode(
      {
        'wynkid': wynkid,
        'code' : code
      }
  );
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print('getRidedetails: ${dataBody}');
    return dataBody;
  }
  catch(e){print(e);return null;}

}

Future<Map<String, dynamic>?> updateRideInfo({

  required String wynkid,
  required String code,
  required LatLng currentPos,
  required int rideStat
}) async {
  print('$wynkid,$code,$rideStat,$currentPos');
  var url = await Uri.parse ('$wynkBaseUrl/update-ride-info');
  var body = json.encode(
      {
        'wynkid': wynkid,
        'ride_code' : code,
        'ride_status': rideStat,
        'currentLat': currentPos.latitude,
        'currentLong': currentPos.longitude
      }
  );
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print('update ride info ${dataBody}');
    return dataBody;
  }
  catch(e){print(e);return null;}

}
Future<Map<String, dynamic>?> tripStarted({required String otp}) async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  print('$otp');
  var url = await Uri.parse ('$wynkBaseUrl/ride-start-otp-process');
  var body = json.encode(
      {
        'otp': otp,
        'wynkid' : prefs.getString('Origwynkid'),
      }
  );
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print('ride start otp process: ${dataBody}');
    return dataBody;
  }
  catch(e){print(e);return null;}

}
Future<Map<String, dynamic>?> sendWhatsappMessage({required String num,required String text})async{
  var url = await Uri.parse ('https://wa.me/$num?text=$text');
  var response = await http.post(
    url
  );
  var dataBody= json.decode(response.body);
  print('send status: ${dataBody}');
 // return dataBody;

}
Future<Map<String, dynamic>?> rideStatus({required String rideCode}) async {

  var url = await Uri.parse ('$wynkBaseUrl/get-ride-status');
  var body = json.encode(
      {
        'ride_code': rideCode,
      }
  );
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print('ride status: ${dataBody}');
    return dataBody;
  }
  catch(e){print(e);return null;}

}
Future<Map<String, dynamic>?> disableNotif({required String rideId,required String wynkid}) async {
  print('$rideId, $wynkid');
  var url = await Uri.parse ('$wynkBaseUrl/disable-notification');
  var body = json.encode(
      {
        'wynkid': wynkid,
        'id': rideId
      }
  );
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print('disableNotif: ${dataBody}');
    return dataBody;
  }
  catch(e){print(e);return null;}

}
Future<String> getActualLocale() async {
  Uri uri = Uri.parse(
      'http://ip-api.com/json');
  var response = await http.get(uri);
  var data = json.decode(response.body);
  return data['countryCode'].toLowerCase();}
final infoKey = "ae1fc6689028c2c53a8f18fcec7c5103-5ffc07c9-5a8e-4768-81de-723d661ceaf9";
void getInfobipApp()async{

  var url = await Uri.parse ('https://qgvnxr.api.infobip.com/webrtc/1/applications');
  var response = await http.get(
    url,
    headers: {
      "Authorization": "App $infoKey",
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
  );
  var dataBody= json.decode(response.body);
  print('getApp, ${dataBody}');
  return dataBody;

}
void infobipVoiceCall()async{

  var url = await Uri.parse ('https://qgvnxr.api.infobip.com/calls/1/calls');
  var body = json.encode({

    "endpoint": {
      "phoneNumber": "2348106052327",
      "type": "PHONE"
    },
    "from":"Alice",
    "applicationId":"d8d84155-3831-43fb-91c9-bb897149a79d"
  });
  var response = await http.post(
    url,
    headers: {
      "Authorization": "App $infoKey",
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: body
  );
  var dataBody= json.decode(response.body);
  print('infobip V Call, ${dataBody}');
  return dataBody;

}

infobipCall()async{
final toks = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhcHAiOiI2ZGI0Yjk5NC04MjVhLTRmOTQtOGMwNi01NDc4MDZjMDMzZDIiLCJpZGVudGl0eSI6IkFsaWNlIiwiaXNzIjoiSW5mb2JpcCIsIm5hbWUiOiJBbGljZSBpbiBXb25kZXJsYW5kIiwibG9jYXRpb24iOiIiLCJleHAiOjE2NjQ0MjcxODAsImNhcHMiOltdfQ.Yfs_MiTVY3V7R2ZEhANwJaBRfgrb32ob11VyDb6rFK0';
  // final val = await genInfobipToken();
  // final token = val['token'];
  myCallListener callEventListener = myCallListener();
  final callRequest = CallRequest(toks, 'test_destination', callEventListener);
  final outgoingCall = await InfobipRTC.call(callRequest);
  print(outgoingCall.status);
}
final appId = 'd8d84155-3831-43fb-91c9-bb897149a79d';

class myCallListener implements CallEventListener{


  @override
  void onEarlyMedia() {
    // TODO: implement onEarlyMedia
  }

  @override
  void onError(CallErrorEvent callErrorEvent) {
    // TODO: implement onError
  }

  @override
  void onEstablished(CallEstablishedEvent callEstablishedEvent) {
    // TODO: implement onEstablished
  }

  @override
  void onHangup(CallHangupEvent callHangupEvent) {
    // TODO: implement onHangup
  }

  @override
  void onRinging() {
    // TODO: implement onRinging

  }

  @override
  void onUpdated(CallUpdatedEvent callUpdatedEvent) {
    // TODO: implement onUpdated
  }



}
Future genInfobipToken()async{

  var url = await Uri.parse ('https://qgvnxr.api.infobip.com/webrtc/1/token');
  var body = json.encode({
  "identity": "Alice",
  "applicationId": appId,
  "displayName": "Alice in Wonderland",
  });
  var response = await http.post(
    url,
    headers: {
     "Authorization": "App $infoKey",
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('infobip token: ${dataBody}');
  return dataBody;

}

Future ridePayment({required String captainWynkId,required String? rideCode,String? paymentMeans})async{

  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('${ prefs.getString('Origwynkid')},$captainWynkId,$rideCode,$paymentMeans');
  var url = await Uri.parse ('$wynkBaseUrl/wynk-pay-for-ride');
  var body = json.encode({
    'patron_wynkid': prefs.getString('Origwynkid'),
    'captain_wynkid': captainWynkId,
    'ride_code': rideCode,
    'payment_means': paymentMeans,
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',

    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('wynk pay for ride: $dataBody');
  return dataBody;
}

Future<Map<String, dynamic>?> getUserType() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/get-user-type');
  var body = json.encode(
      {
        'wynkid' : prefs.getString('Origwynkid'),
      }
  );
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    var dataBody= json.decode(response.body);
    print('user type: ${dataBody}');
    return dataBody;
  }
  catch(e){print(e);return null;}

}

Future getCaptains({required LatLng position})async{

  var url = await Uri.parse ('$wynkBaseUrl/get-captains-around');
  print(position);
  var body = json.encode({
    'latitude':position.latitude,
    'longitude':position.longitude
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('captains: $dataBody');
  return dataBody;
}

Future getCurrentPass()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/getCurrentPass');
  print(prefs.getString('Origwynkid'));
  var body = json.encode({
    'captain_wynkid': prefs.getString('Origwynkid')
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('Current Pass: $dataBody');
  return dataBody;
}

Future payForPass({required String passId})async{
  print('pass id: $passId');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/pay-for-pass');
  var body = json.encode({
    'captain_wynkid': prefs.getString('Origwynkid'),
    'pass_id':passId
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('pass purchase status: $dataBody');
  return dataBody;
}

Future passDetail()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var url = await Uri.parse ('$wynkBaseUrl/get-pass-details');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('pass purchase type: $dataBody');
  return dataBody;
}

Future patronHasPaid(String rideCode)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var url = await Uri.parse ('$wynkBaseUrl/captain-confirm-cash');
  var body = json.encode({
    'captain_wynkid': prefs.getString('Origwynkid'),
    'ride_code': rideCode
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('confirm cash: $dataBody');
  return dataBody;
}

Future walletDetails(BuildContext context)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  context.read<WalletDetails>().wallets.clear();
  var url = await Uri.parse ('$wynkBaseUrl/user-wallet-details');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('wallet details: $dataBody');
  return dataBody;
}

Future createWallet(String? accountName)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var url = await Uri.parse ('$wynkBaseUrl/create-new-wallet');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
    'wallet_name':accountName
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('add account: $dataBody');
  return dataBody;
}

Future walletLookup(String? walletNumber)async{

  var url = await Uri.parse ('$wynkBaseUrl/wallet-lookup');
  var body = json.encode({
    'wallet_number': walletNumber,
  });

  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('wallet lookup: $dataBody');
  return dataBody;
}

Future wallet2wallet(String? fromWallet, String? toWallet, String? amount)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
print('$fromWallet,$toWallet,$amount');
  var url = await Uri.parse ('$wynkBaseUrl/wallet-2-wallet');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
    'from_wallet':fromWallet,
    'to_wallet': toWallet,
    'amount': amount

  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('send funds: $dataBody');
  return dataBody;
}

Future capRideHist()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var url = await Uri.parse ('$wynkBaseUrl/captain-ride-history');
  var body = json.encode({
    'captain_wynkid': prefs.getString('Origwynkid'),

  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('captain ride history: $dataBody');
  return dataBody;
}

Future commBanks()async{

  var url = await Uri.parse ('$wynkBaseUrl/bank-list');

  var response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  var dataBody= json.decode(response.body);
  print('b: $dataBody');
  return dataBody;
}

Future getAccountDetails( String accNum, String accType, String bankCode)async{
print('$accNum,,$bankCode,$accType');
  var url = await Uri.parse ('$wynkBaseUrl/account-details-lookup');
  var body = json.encode({
   'account_number': accNum,
    'account_type':accType,
    'bank_code':bankCode

  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('account details: $dataBody');
  return dataBody;
}

Future wallet2Bank(String? accNum, String? fromWallet, String? amount,String beneName,String? destBankCode)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
print('$accNum,$fromWallet,$amount,$beneName,$destBankCode');
  var url = await Uri.parse ('$wynkBaseUrl/wallet-2-bank');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
    'account_number':accNum,
    'beneficiary_name':beneName,
    'from_wallet': fromWallet,
    'amount': amount,
    'bank_code':destBankCode

  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody= json.decode(response.body);
  print('send funds: $dataBody');
  return dataBody;
}

Future getNubanDet()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/get-nuban-details');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body
  );
  var dataBody= json.decode(response.body);
  print('nu: $dataBody,${prefs.getString('Origwynkid')}');
  return dataBody;
}

Future savePicture(String img, String wynkid)async{
  print('$wynkid...$img..');
  var url = await Uri.parse ('$wynkBaseUrl/save-picture');
  var body = json.encode({
    'wynkid': wynkid,
    'picture': img
  });
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );
  var dataBody= json.decode(response.body);
  print('save picture: $dataBody');
  return dataBody;
}

Future requestFunds(String fromWallet,String toWallet, String amount)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('$fromWallet...$toWallet...$amount');
  var url = await Uri.parse ('$wynkBaseUrl/request-fund');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
    'to_wallet': toWallet,
    'from_wallet':fromWallet,
    'amount':amount
  });
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );
  var dataBody= json.decode(response.body);
  print('request funds: $dataBody');
  return dataBody;
}

Future responseFromPhone(String phoneNumber)async{
  var url = await Uri.parse ('$wynkBaseUrl/response-details');
  var body = json.encode({
    'phone': phoneNumber
  });
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );
  var dataBody= json.decode(response.body);
  print('response details: $dataBody');
  return dataBody;
}

Future airtime(String phone,String service, String channel, String wallet,String amount)async{
  print('airtiming');
  print('$phone,$channel,$wallet,$amount');
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var url = await Uri.parse ('$wynkBaseUrl/airtime');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
    'phone_number': phone,
    'channel':channel,
    'wallet_number': wallet,
    'amount':amount
  });
  Response ress =await Dio().post('$wynkBaseUrl/airtime',data: body);
  print('airtiming2');
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );

  var dataBody= json.decode(ress.data);
  print('airtime: $dataBody');
  selectWalletCont.clear();
  airtimeAmountCont.clear();
  contactSearchCont.clear();
  return dataBody;
}

Future dataLookup (String channel)async{
  var url = await Uri.parse ('$wynkBaseUrl/lookup-data');
  var body = json.encode({
    'channel':channel
  });
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );
  var dataBody= json.decode(response.body);
  print(dataBody);
  return dataBody;
}

Future dataPurchase(String phone,String service, String productCode, String wallet,String amount)async{
  print('$phone,$service,$productCode,$wallet,$amount');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/data-purchase');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
    'phone_number': phone,
    'productCode':productCode,
    'wallet_number': wallet,
    'amount':amount,
    'service':service
  });
  print('data1');
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );
  print(response.body);
  var dataBody= json.decode(response.body);
  print('data2');
  print('da pu: $dataBody');
  return dataBody;
}

Future getUtilities ()async{
  var url = await Uri.parse ('$wynkBaseUrl/disco-list');

  var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      });
  var dataBody= json.decode(response.body);
  print('uti: $dataBody');
  return dataBody;
}

Future lookupPower(String meterNo,String accType, String fromWallet,String amount,String shortName)async{
  print('$meterNo,$accType,$fromWallet,$shortName,$amount');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/lookup-power');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
    'meterNo': meterNo,
    'short_name':shortName,
    'accountType': accType,
    'amount':amount,
    'wallet_number':fromWallet
  });
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );
  var dataBody= json.decode(response.body);
  print('lookup power: $dataBody');
  return dataBody;
}

Future purchasePower(String shortName,String cRef, String fromWallet,String amount,String pCode)async{
  print('$pCode,$cRef,$fromWallet,$shortName,$amount');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print( prefs.getString('Origwynkid'));
  var url = await Uri.parse ('$wynkBaseUrl/lookup-power');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
    'short_name': shortName,
    'clientReference':cRef,
    'productCode': pCode,
    'amount':amount,
    'wallet_number':fromWallet
  });
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );
  var dataBody= json.decode(response.body);
  print('lookup power: $dataBody');
  return dataBody;
}

Future<Map<String, dynamic>> multiChoiceLookup(String tvType) async {
  var url = await Uri.parse('$wynkBaseUrl/lookup-multichoice');
  var body = json.encode({
    "channel": tvType
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody = json.decode(response.body);
  print('multi choice lookup: $dataBody');
  return dataBody;
}

Future<Map<String, dynamic>> multichoiceValidate(String channel,String smartcode) async {
  var url = await Uri.parse('$wynkBaseUrl/validate-multichoice');
  var body = json.encode({
    "channel":channel,
    "smartCardCode":smartcode
  });
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody = json.decode(response.body);
  print('multi choice validate: $dataBody');
  return dataBody;
}

Future<Map<String, dynamic>> multichoicePurchase(
    String code,
    String amount,
    String productCode,
    String wallet,
    ) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse('$wynkBaseUrl/purchase-multichoice');
  print('$code,$amount,$productCode,$wallet');
  var body = json.encode({
    "wynkid":prefs.getString('Origwynkid'),
    "code":code,
    "totalAmount":amount,
    "productCode": productCode,
    "from_wallet":wallet
  });var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody = json.decode(response.body);
  print('multi choice validate: $dataBody');
  return dataBody;
}

Future<Map<String, dynamic>> resetPin(String newPin,) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse('$wynkBaseUrl/update-pin');
  var body = json.encode({
    "pin":newPin,
    "wynkid": prefs.getString('Origwynkid')
  });var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  var dataBody = json.decode(response.body);
  print('newPin res: $dataBody');
  return dataBody;
}

Future<Map<String, dynamic>> smileLookup(String account) async {

  var body = json.encode({
    "account": account
  });
  Response response = await Dio().post('$wynkBaseUrl/lookup-smile',data: body);
  var dataBody = json.decode(response.data);
  print('smile lookup: $dataBody');
  return dataBody;
}

Future<Map<String, dynamic>> smileValidate(String account) async {

  var body = json.encode({
    "account": account
  });
  Response response = await Dio().post('$wynkBaseUrl/smile-validate',data: body);
  var dataBody = json.decode(response.data);
  print('smile validate: $dataBody');
  return dataBody;
}

Future<Map<String, dynamic>> smilePurchase(String account,String code, String amount,String productCode,String fromWallet ) async {
  print('$account,$code,$amount,$productCode,$fromWallet');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var body = json.encode({
    "wynkid":prefs.getString('Origwynkid'),
    "account": account,
    "wallet_number":fromWallet,
    "code":code,
    "productCode":productCode,
    "amount":amount
  });
  Response response = await Dio().post('$wynkBaseUrl/smile-subscribe',data: body);
  var dataBody = json.decode(response.data);
  print('smile purchase: $dataBody');
  return dataBody;
}

Future<Map<String, dynamic>> earnings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var body = json.encode({
    "wynkid": prefs.getString('Origwynkid')
  });
  Response response = await Dio().post('$wynkBaseUrl/todays-earnings-history',data: body);
  var dataBody = json.decode(response.data);
  return dataBody;
}