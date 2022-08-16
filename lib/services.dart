import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/login_feature/login_page.dart';
import 'package:untitled/features/verification_feature/confirm_transaction_pin.dart';
import 'package:untitled/main.dart';
import 'controllers.dart';
import 'utilities/models/data_confirmation.dart';
import 'features/registration_feature/register_page.dart';
import 'features/registration_feature/sign_up_personal_details.dart';
  String wynkBaseUrl='https://wynk.ng/stagging-api';
showToast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
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
  print('$uId,3');
  Map userData = await postRequest(WynkId: uId, IDNum: idNumController.text, IDType: context.read<FirstData>().UserSelectedId);
  print(context.read<FirstData>().UserSelectedId);
  print('$userData,4');
  if(userData['statusCode']=='User information not found in the database. Please check and try again.'){
    showToast('User information not found in the database. Please check and try again.');
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
  }
 else {await postRequest2(FirstName: firstNameController.text, LastName: lastNameController.text, WynkId:uId);
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
  String pic=userData3["smallpassport"];
  context.read<FirstData>().getUserImgUrl('http://wynk.ng/stagging-api/picture/$pic');
  print('post requesting completed');
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
  String userNum = '$numCode${userNumLogController.text}';
  String userNumber = userNum.substring(1);
  print('started');
  final prefs=await SharedPreferences.getInstance();
  var url = Uri.parse ('$wynkBaseUrl/login_process');
  print('${userNumLogController.text},$pin');
  var body = json.encode({
    'username':prefs.getString('Origwynkid')??userNumber,
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
  print('$dataBody,1');
  await prefs.setString('firstname', dataBody['firstname']);
  return dataBody;

}
String destination = '';
Future<Map<String, dynamic>?> lookForCaptain({required LatLng pickupPos, required LatLng destPos, required String wynkid}) async {
  List <Placemark> pickup = await placemarkFromCoordinates(pickupPos.latitude,pickupPos.longitude);
  List <Placemark> destination = await placemarkFromCoordinates(destPos.latitude,destPos.longitude);

  print(pickup[0].street);
  print(destination[0].street);
  var url = await Uri.parse ('$wynkBaseUrl/seacrch-captain');
  print('reached 1');
  var body = json.encode({
    'wynkid': wynkid,
    'loading':pickup[0].street,
    'destination':destination[0].street
  });
  print('reached 2');
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    print('reached 3');
    var dataBody= json.decode(response.body);
    print('reached 4');
    print('ufd ${dataBody}');
    return dataBody;
  }
  catch(e){print(e);return null;}

}
Future<Position> determinePosition(BuildContext context)async{
  bool? serviceEnabled;
  LocationPermission? permission;
  serviceEnabled= await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled){
    await Geolocator.requestPermission();
    return Future.error('Location services are disabled');
  }
  permission=await Geolocator.checkPermission();
  if(permission==LocationPermission.denied){

    permission=await Geolocator.requestPermission();
    if(permission==LocationPermission.denied){
      return Future.error('Location permission are denied');
    }
  }

  return await Geolocator.getCurrentPosition();

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
  print('$dataBody, stored');
  print('now, ${response.statusCode}');
}


