import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' ;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as htp;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wynk/features/login_feature/login_page.dart';
import 'package:wynk/features/registration_feature/otherRegNIn.dart';
import 'package:wynk/features/verification_feature/confirm_transaction_pin.dart';
import 'package:wynk/main.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/widgets.dart';
import 'controllers.dart';
import 'utilities/models/data_confirmation.dart';
import 'features/registration_feature/register_page.dart';
import 'features/registration_feature/sign_up_personal_details.dart';
  String wynkBaseUrl='https://wynk.ng/stagging-api';

  showSnackBar(BuildContext context, String msg){
    final snackBar = SnackBar(
      backgroundColor: kBlueTint,
      content:  Text(msg,style: TextStyle(color: Colors.white),),
      action:SnackBarAction(
        textColor: kYellow,
        label:  'Dismiss',onPressed: (){},
      )
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
  );}
 var http =  htp.Client();
  Future<Map<String, dynamic>> postRequest({required String? phone, required String? IDNum,required String? WynkId}) async {
    var url = await Uri.parse ('https://wynk.ng/stagging-api/authenticate-verifyme');
    var body = json.encode({
      "verification_type": "phone_number",
      "verification_number": phone,
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
    "email": email,
    "referral_code": referralCode,
    "address": address,
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

String? userMobile;
Future<int> getVerificationDetails(BuildContext context)async {

  String? uId=context.read<FirstData>().uniqueId;
  Map userData = await postRequest(WynkId: uId, IDNum: idNumController.text, phone: context.read<FirstData>().userNumber);
  if(userData['statusCode']=='201'){
    Navigator.pop(context);
    showSnackBar(context,userData['errorMessage']);
    showDialog(context: context, builder: (context){
      return AlertDialog();
    });
    return 0;
  }
 else {
    Map userData2 = await postRequest2(FirstName: firstNameController.text, LastName: lastNameController.text, WynkId:uId);
    if(userData2['statusCode'] == 201){
      print('this');

      showSnackBar(context, userData2['errorMessage']);

      return 2;
    }
    else{
  Map userData3= await postRequest3(WynkId:uId);

  if(userData3["phone"]==null){
    context.read<FirstData>().checkUserRegStat(true);
  showToast('It seems you have a record with us.');
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const LoginPage()
  ));
  return 0;
  }

  else{
    print('jjjjjjjjjjjjjjjj');
  confirmationPhoneCont.text=userData3["phone"];
  confirmationFirstnameCont.text=userData3['firstname'];
  confirmationLastnameCont.text=userData3['lastname'];
  confirmationDobCont.text=userData3['birthdate'];
  confirmationDocIDCont.text=idNumController.text;
  confirmationEmailCont.text=emailController.text;
  context.read<FirstData>().getUserImgUrl(userData3['passport']);
  print('post requesting completed');
  //Navigator.pop(context);
  return 1;
}}}
}
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
Future<Map<String, dynamic>> resendOtp({required String userMobileNo}) async {
  var url = await Uri.parse ('$wynkBaseUrl/resend-otp');
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
refresh(BuildContext context)async{

  final res = await walletDetails(context);
  final userDet =await getCapDetails(context.read<FirstData>().uniqueId);
  context.read<WalletDetails>().wallets.clear();
  final wallets = res['message']as List;
  context.read<FirstData>().saveVaultB(wallets[0]['actualBalance'].toString());
  context.read<FirstData>().saveTodayEarning(userDet['todayearning'].toString());
  context.read<FirstData>().saveAverageRating(userDet['averagerating'].toString());
  context.read<FirstData>().saveTodayTrip(userDet['todaytrip'].toString());
  accountBalCont.text =  '₦${context.read<FirstData>().vaultB}';
  for(var wallet in wallets){
    Wallet wal = Wallet(walletName: wallet['walletname'],
        walletNum: wallet['walletnumber'], currentBalance: wallet['actualBalance']);
    context.read<WalletDetails>().saveWallet(wal);
  }
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

  // Map otpGenBody = {
  //   "SMS": {
  //     "auth": {
  //       "username": "olumideogundele@gmail.com",
  //       "apikey": "b97826d6ae9b6356f3f803e3692b4d6122360ddb"
  //     },
  //     "message": {
  //       "sender": "Wynk",
  //       "messagetext": "Your Wynk registration One Time Password(OTP) is $otp. Please use it within 3 minutes.",
  //       "flash": "0"
  //     },
  //     "recipients":
  //     {
  //       "gsm": [
  //         {
  //           "msidn": "$userMobile",
  //           "msgid": "uniqueid1"
  //         },
  //       ]
  //     }
  //   }
  // };
  // Future<Map<String, dynamic>> getOtp(BuildContext context) async {
  //   userMobile=Provider.of<FirstData>(context,listen: false).userNumber;
  //   print(userMobile);
  //   var url = await Uri.parse(otpUrl);
  //   var body = json.encode(otpGenBody);
  //   var response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: body,
  //   );
  //   var dataBody = json.decode(response.body);
  //   print(dataBody);
  //   return dataBody;
  // }
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
   // showSnackBar(context, 'Location services are disabled');
    Navigator.pop(context);
    await Geolocator.requestPermission();
    await Geolocator.openLocationSettings();
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
  try{
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
  catch(e){
    showSnackBar(context, e.toString());
  }
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

Future getNubanDet(BuildContext context)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/get-nuban-details');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
  });
  try{
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
  catch (error){
    showSnackBar(context, error.toString());
    return null;
  }
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
  print('airtiming000000000000000000000000000000000000000');
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
  print('airtiming2');
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );

  var dataBody= json.decode(response.body);
  print('airtime: $dataBody');
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
Future transHist ()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/transaction-history');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid')
  });
  var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body
  );
  var dataBody= json.decode(response.body);
  print('transH $dataBody');
  return dataBody;
}

Future dataPurchase(String phone,String service, String productCode, String wallet,String code)async{
  print('$phone,$service,$productCode,$wallet,$code');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = await Uri.parse ('$wynkBaseUrl/data-purchase');
  var body = json.encode({
    'wynkid': prefs.getString('Origwynkid'),
    'phone_number': phone,
    'productCode':productCode,
    'wallet_number': wallet,
    'code':code,
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

Future<Map<String, dynamic>> submitReg(BuildContext context) async {

  var body = json.encode({
    "v_nin":virtNin.text,
    "o_nin": origNin.text,
    "wynkid": context.read<FirstData>().uniqueId,
    "address": permAddressController.text,
    "firstname":firstNameController.text,
    "lastname":lastNameController.text,
    "email":emailController.text,
    "referral_code":refCodeController.text,
  });
  Response response = await Dio().post('$wynkBaseUrl/registeration-process-nin',data: body);
  var dataBody = json.decode(response.data);
  print('sec reg: $dataBody');
  return dataBody;
}
Future getCharges ()async{
  var url = await Uri.parse ('$wynkBaseUrl/get-charges-billspay');

  var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },

  );
  var dataBody= json.decode(response.body);
  print('charges breakdown $dataBody');
  return dataBody;
}
openMap(double lat, double long)async{
  String googleUrl = 'https://www.google.com/maps/search/?saddr=7.1,5.1&daddr=$lat,$long&directionsmode=driving';
  if(await canLaunchUrl(Uri.parse(googleUrl))){
    await launchUrl((Uri.parse(googleUrl)));
  }
  else{
    throw 'Could not open Map.';
  }
}