import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/features/ride_schedule/ride_schedule%20pickup.dart';
import 'package:wynk/services.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/widgets.dart';

import 'dart:io';
import 'controllers.dart';
import 'features/firebase/ride_schedule.dart';
import 'features/landing_pages/captain_home.dart';
import 'features/landing_pages/captain_online.dart';
import 'features/landing_pages/home_main14.dart';
import 'features/later_screens/patron_trip_ended.dart';
import 'features/local_notif.dart';
import 'features/login_feature/another_user_login.dart';
import 'features/payments/payment_list.dart';
import 'features/registration_feature/patron_captain_login.dart';
import 'features/registration_feature/register_page.dart';
import 'features/ride/nav_screen.dart';
import 'features/ride/patron_invoice.dart';
import 'features/ride/patron_ride_commence.dart';
import 'features/ride/ride_available.dart';
import 'features/ride/ride_destination.dart';
import 'features/ride/ride_home.dart';
import 'features/landing_pages/welcome_page.dart';
import 'features/ride/ride_in_progress.dart';
import 'features/ride/ride_payment_gateway.dart';
import 'features/ride/ride_started.dart';
import 'features/ride/trip_ended.dart';
import 'features/ride_schedule/ride_schedule_dest.dart';
import 'features/rides.dart';
import 'features/vault/add_funds.dart';
import 'features/vault/add_funds2.dart';
import 'features/vault/add_funds3.dart';
import 'features/vault/add_funds4.dart';
import 'features/vault/add_funds5.dart';
import 'features/vault/add_funds_payment_gateway].dart';
import 'features/vault/vault_home.dart';
import 'features/wynk-pass/wynk_sub_page.dart';
import 'utilities/firebase_dynamic_link.dart';


AndroidNotificationChannel notificationChannel = AndroidNotificationChannel(
    'high',
    'name',
    'description',
    importance: Importance.high,
    playSound: true
) ;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
  print('a bg message just showed up : ${message.messageId}');
}
PendingDynamicLinkData? initialLink;



Future <void> main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await  NotificationService().init();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp]
  );
  if(defaultTargetPlatform == TargetPlatform.android){
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>
    ()?.createNotificationChannel(notificationChannel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirstData()),
        ChangeNotifierProvider(create: (_) => PassSubDetails()),
        ChangeNotifierProvider(create: (_) => RideDetails()),
        ChangeNotifierProvider(create: (_) => CaptainDetails()),
        ChangeNotifierProvider(create: (_) => RideBooking()),
        ChangeNotifierProvider(create: (_) => WalletDetails()),
      ],
      child:  ScreenUtilInit(
        designSize: const Size(390,844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          FirebaseMessaging.onMessage.listen((message) {
            RemoteNotification? notification = message.notification;
            AndroidNotification? android = message.notification?.android;
            if(notification != null && android != null){
              FlutterLocalNotificationsPlugin().show(
                  notification.hashCode,
                  notification.title,
                  notification.body,
                  NotificationDetails(
                      android: AndroidNotificationDetails(
                        notificationChannel.id,
                          notificationChannel.name,
                          notificationChannel.description,
                          color: kBlue,

                          playSound: true,
                          importance: Importance.max,
                          priority: Priority.max,
                          visibility: NotificationVisibility.public
                      )
                  ),
              );
            }
          });
          FirebaseMessaging.onMessageOpenedApp.listen((message) {
            RemoteNotification? notification = message.notification;
            AndroidNotification? android = message.notification?.android;
            if(notification != null && android != null){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text(notification.title!),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.body!)
                    ],),
                  ),
                );
              });
            }
          });
          return MyApp();
        },

      )
    ),
  );
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context)=>  SplashScreen(link: initialLink,),
        '/Home' : (context)=> const HomeMain14(),
        '/UserSelector' : (context)=> const UserSelector(),
        '/CaptainHome' : (context)=> const CaptainHome(),
        '/RideSchedule' : (context)=>  RideSchedule(),
        '/RideSchedulePickup' : (context)=>  RideSchedulePickup(),
        '/RideSchDestination' : (context)=>  RideSchDestination(),
         '/WelcomePage' : (context)=> const WelcomePage(),
        '/VaultHome' : (context)=> const VaultHome(),
        '/NavScreen' : (context)=>  NavScreen(),
        '/AddFunds' : (context)=>  AddFunds(),
        '/AddFunds2' : (context)=>  AddFunds2(),
        '/AddFunds3' : (context)=>  AddFunds3(),
        '/AddFunds4' : (context)=>  AddFunds4(),
        '/AddFunds5' : (context)=>  AddFunds5(),
        '/AddFundsGateway' : (context)=> const VaultPaymentGateway(),
        '/CaptainOnline' : (context)=>  CaptainOnline(),
        '/RideCommence' : (context)=>  RideCommence(),
        '/RideDestination' : (context)=>  RideDestination(),
        '/RideEnded' : (context)=>  PatronInvoice(),
        '/RideInProgress' : (context)=>  RideInProgress(),
        '/RideStarted' : (context)=>  RideStarted(),
        '/RiderAvailable' : (context)=>  RiderAvailable(),
        '/RidePaymentGateway' : (context)=>  RidePaymentGateway(),
        '/PatronTripEnded' : (context)=>  PatronTripEnded(),
        '/PassHome' : (context)=>  WynkPassHome(),
        '/TripEnded' : (context)=>  TripEnded(),
        '/RidesList' : (context)=>  RidesList(),
        '/Payments' : (context)=>  PaymentList(),

      },
      theme: ThemeData(
          fontFamily: 'SF-Pro-Text',
          primaryColor: kBlue),
        debugShowCheckedModeBanner: false);
  }
}
class WalletDetails with ChangeNotifier{
  List<Wallet> wallets = [];
  saveWallet(Wallet val){
    wallets.add(val);
    notifyListeners();
  }
}
class FirstData with ChangeNotifier{

  bool visible = true;
  List<ChatTile> messages = [ChatTile(text: 'You are welcome', color: Colors.green, time: 'Just now')];
  LatLngBounds? latLngBounds;
  String? userType;
  double? lat;
  double? long;
  String? userP;
  String? uniqueId;
  String? otpNumFromServer;
  String? userNumber;
   bool? openCamera;
   List<Marker> captains= [];
   File? providerImage;
   String? userImgUrl;
   String? userVerEndpoint;
   String? UserSelectedId;
   String? username;
   bool? isReg;
   bool? isCaptainReg;
  bool? showTopbar = true;
  bool? showBackbutton = false;
  String? user;
  int? selectedNetwork;
  BitmapDescriptor? startMarker;
  BitmapDescriptor? destMarker;
  BitmapDescriptor? currMarker;
  String? paymentMeans;
  bool? goToHome;
  LatLng? patronCurentLocation;
  bool? showLoginNotif;
  DetailsResult? startPos;
  DetailsResult? endPos;
  Timer? timer;
  String? profImgUrl;
  LatLng? updateLocation;
  double? updateRotation;
  Uint8List? curMarker2;
  String? patronPickupPlace;
  String? patronDestPlace;
  String? totalDuration;
  String? rideImage;
  String vaultB = '---';
  String? todayEarning;
  String? averageRating;
  String? todayTrip;
  String? origUserType;
  List<RideDetail> rides = [];
  List<ListTile> utilities = [];
  List<ListTile> transcards = [];
  String? serviceUnit;
  bool activeRide = false;

  saveActiveRide(bool val){
    activeRide = val;
    notifyListeners();
  }
  String? fromWallet;
  saveFromWallet(String val){
    print(val);
    fromWallet = val;
    notifyListeners();
  }
  PendingDynamicLinkData? dataLink;
  savePendingDataLink(PendingDynamicLinkData val){
    dataLink = val;
    notifyListeners();
  }
  saveServiceUnit(String val){
    serviceUnit = val;
    notifyListeners();
  }
  saveUtil(ListTile val){
    utilities.add(val);
    notifyListeners();
  }
  saveTransCard(ListTile val){
    transcards.add(val);
    notifyListeners();
  }
  String? numCode;
  saveNumCode(String val){
    numCode = val;
    notifyListeners();
  }
  bool? numComplete;
  saveNumComplete(bool val){
    numComplete = val;
    notifyListeners();
  }
  saveRideDetail(RideDetail val){
    rides.add(val);
    notifyListeners();
  }
  saveOriguser(String val){
    origUserType = val;
    notifyListeners();
  }
  saveCaps(Marker val){
    captains.add(val);
    notifyListeners();
  }

  saveTodayTrip(String? val){
    todayTrip = val;
    notifyListeners();
  }
  saveAverageRating(String? val){
    averageRating = val;
    notifyListeners();
  }
  saveTodayEarning(String? val){
    todayEarning = val;
    notifyListeners();
  }
  saveVaultB(String val){
    vaultB = val;
    notifyListeners();
  }
  saveTotalDuration(String val){
    totalDuration = val;
    notifyListeners();
  }
  saveRideImage(String val){
    rideImage = val;
    notifyListeners();
  }
  savePatronPickupPlace(String val)async{
    patronPickupPlace = val;
    notifyListeners();
  }
  savePatronDestPlace(String val)async{
    patronDestPlace = val;
    notifyListeners();
  }

  saveCurMarker2(Uint8List val)async{
    curMarker2 = val;
    notifyListeners();
  }
  saveProfImg(String val)async{
    profImgUrl = val;
    notifyListeners();
  }

  updateRotat(double val){
    updateRotation = val;
    notifyListeners();
  }

   updateLocat(LatLng val){
     updateLocation = val;
     notifyListeners();
  }

  saveStartPos(DetailsResult val){
    startPos = val;
    notifyListeners();
  }

  saveEndPos(DetailsResult val){
    endPos = val;
    notifyListeners();
  }
  savePCLocat(dynamic val){
    patronCurentLocation = val;
    notifyListeners();
  }

  checkRideStarted(String rideCode)async{
    timer = Timer.periodic(Duration(seconds: 20), (_) async {
     dynamic val = await rideStatus(rideCode: rideCode);
     if(val['status_code'] == '8'){
       NotificationService.showNotif('Wynk Ride', 'Ride has Started.');
       timer?.cancel();
     };
    });
  }

  saveShowLoginNotif(bool? val){
    showLoginNotif = val;
    notifyListeners();
  }
  saveGTHome(bool? val){
    goToHome = val;
    notifyListeners();
  }
  savePaymentMeans(String? val){
    paymentMeans = val;
    notifyListeners();
  }
  saveSelNet(int val){
    selectedNetwork = val;
    notifyListeners();
  }
  saveStartMarker(BitmapDescriptor val){
    startMarker = val;
    notifyListeners();
  }
  saveDestMarker(BitmapDescriptor val){
    destMarker = val;
    notifyListeners();
  }

  saveCurMarker(BitmapDescriptor val){
    currMarker = val;
    notifyListeners();
  }

  saveUser(String val){
    user = val;
    notifyListeners();
  }
  changeVisibility(){
    visible =!visible;
    notifyListeners();
  }

  saveUserType(String val){
    userType = val;
    notifyListeners();
  }
  addChat(ChatTile chat){
    messages.add(chat);
    notifyListeners();
  }
  checkCapRegStat(bool isCapReg){
    isCaptainReg=isCapReg;
    notifyListeners();
  }
  topBar(bool topBarVisibility){
    showTopbar=topBarVisibility;
    notifyListeners();
  }

  backButton(bool backButVis){
    showBackbutton = backButVis;
    notifyListeners();
  }
   saveCurrentLocat(double lt, double lng){
     lat=lt;
     long=lng;
     notifyListeners();
   }
  saveLatLngBounds(LatLngBounds llb){
    latLngBounds=llb;
    notifyListeners();
  }

  checkUserRegStat(bool isreg){
    isReg=isReg;
    notifyListeners();
  }
   getUserP(String? incomingP){
     userP=incomingP;
     notifyListeners();
   }
  getUsername(String? incomingN){
    username=incomingN;
    notifyListeners();
  }

  getSelectedId(String? selectedId){
    UserSelectedId=selectedId;
    notifyListeners();
  }
   getUserVerEndpoint(String? userEndPBId){
     userVerEndpoint=userEndPBId;
     notifyListeners();
   }
  getUserImgUrl(String? userImgUrInput){
    userImgUrl=userImgUrInput;
    notifyListeners();
  }
  getOtpNumberFromServer(String? otp){
    otpNumFromServer=otp;
    notifyListeners();
  }
  saveUniqueId(String? uniqueIdIn){
    uniqueId=uniqueIdIn;
    notifyListeners();
  }
   getUserNumber(String? user){
     userNumber=user;
     notifyListeners();
   }
   yesCamera(){
       openCamera=true;
       notifyListeners();

}
  noCamera(){
    openCamera=false;
    notifyListeners();
  }

    imageGotten(File? file){
     providerImage=file;
     notifyListeners();
   }
}
class RideBooking with ChangeNotifier{
  String? pickupTime;
  String? pickupDate;
  LatLng? pickupPos;
  String? pickupPlace;
  String? destPlace;
  LatLng? destPos;

  saveDestPos(LatLng val){
    destPos = val;
    notifyListeners();
  }
  saveDestPlace(String? val){
    destPlace = val;
    notifyListeners();
  }
  savePickupPlace(String? val){
    pickupPlace = val;
    notifyListeners();
  }
  savePickupPos(LatLng val){
    pickupPos = val;
    notifyListeners();
  }
  savePickupTime(String? val){
    pickupTime = val;
    notifyListeners();
  }
  savePickupDate(String? val){
    pickupDate = val;
    notifyListeners();
  }
}
class CaptainDetails with ChangeNotifier{
  String? capPlate;
  String? capId;
  String? rideCode;
  String? capArrivalTime;
  String? fair;
  String? capName;
  String? carBrand;
  String? carModel;
  String? carColor;
  String? capPhone;
  LatLng? captainLocation;
  LatLng? patronLocation;
  String? capRating;
  String? baseFair;
  String? time;
  String? convFee;
  String? roadMaint;
  String? distance;
  String? total;
  saveFairDetails(
      String? baseFair,
      String? time,
      String? convFee,
      String? roadMaint,
      String? distance,
      String? total
      ){
    this.baseFair = baseFair!;
    this.time = time!;
    this.convFee = convFee!;
    this.roadMaint = roadMaint;
    this.distance = distance;
    this.total = total;
    notifyListeners();
  }
  saveFair(String val){
    fair = val;
    notifyListeners();
  }

  String captainArrivalInfo = 'Captain Arrives in';
  saveCapPlate(String? val){
    capPlate = val;
    notifyListeners();
  }
  saveCapArrInfo(String val){
    captainArrivalInfo = val;
    notifyListeners();
  }

  saveCapRating(String? val){
    capRating = val;
    notifyListeners();
  }

  savePatronLocation(LatLng val){
    patronLocation = val;
    notifyListeners();
  }
  saveCaptLocation(LatLng val){
    captainLocation = val;
    notifyListeners();
  }
   savePhone(String val){
     capPhone = val;
     notifyListeners();
   }
  saveCarColor(String val){
    carColor = val;
    notifyListeners();
  }
  saveCapArrTime(String val){
    capArrivalTime = val;
    notifyListeners();
  }
  saveCarBrand(String val){
    carBrand = val;
    notifyListeners();
  }

  saveCarModel(String val){
    carModel = val;
    notifyListeners();
  }
  saveCapId(String val){
    capId = val;
    notifyListeners();
  }
  saveCapName(String val){
    capName = val;
    notifyListeners();
  }
  saveRideCode(String val){
    rideCode = val;
    notifyListeners();
  }
}
class RideDetails with ChangeNotifier{
  String? time;
  String? distance;
  String? pickUp;
  String? fair;
  String? riderName;
  LatLng? pickupPos;
  String? destination;
  String? pickupDate;
  LatLng? destPos;
  String? upperFair;
  String? rideCode;
  String? rideId;
  String? patronWynkid;
  String? paymentMode;
  savePaymentMode(String? val){
    paymentMode = val;
    notifyListeners();
  }
  savePatronWynkid(String val){
    patronWynkid = val;
    notifyListeners();
  }
  saveRideId(String val){
    rideId = val;
    notifyListeners();
  }

  saveRideCode(String val){
    rideCode = val;
    notifyListeners();
  }

  saveDestination(String val){
    destination =val;
    notifyListeners();
  }

  savePickupDate(String val){
    pickupDate = val;
    notifyListeners();
  }
  savePickupPos(LatLng val){
    pickupPos =val;
  }

  saveDestPos(LatLng val){
    destPos =val;
  }
  saveTime(String val){
    time = val;
    notifyListeners();
  }
  saveDistance(String val){
    distance = val;
    notifyListeners();
  }
  savePickup(String val){
    pickUp = val;
    notifyListeners();
  }
  saveFair(String val){
    fair = val;
    notifyListeners();
  }
  saveUpperFair(String val){
    upperFair = val;
    notifyListeners();
  }
  saveRiderName(String val){
    riderName = val;
    notifyListeners();
  }
}
class PassSubDetails with ChangeNotifier{
  Color? passAvatarColor;
  String? passLogo;
  String? passName;
  String? passAmount;
  String? passDuration;
  String? currentPassDur;
  String? currentPassType;
  String? subType;
  List<WhiteWynkPass> prepaidPasses = [];
  List<WhiteWynkPass> postpaidPasses = [];
  String? passId;
  saveCurrPassType(String  val){
    currentPassType = val;
    notifyListeners();
  }
  savePassId(String  val){
    passId = val;
    notifyListeners();
  }
  savePrepaidPass(WhiteWynkPass val){
    prepaidPasses.add(val);
    notifyListeners();
  }
  savePostpaidPass(WhiteWynkPass val){
    postpaidPasses.add(val);
    notifyListeners();
  }
  saveSubType(String inSubType){
    subType = inSubType;
    notifyListeners();
  }

  savePassAvatarColor(Color col){
    passAvatarColor = col;
    notifyListeners();
  }
  savePassLogo(String logo){
    passLogo = logo;
    notifyListeners();
  }
  savePassName(String val){
    passName = val;
    notifyListeners();
  }
  savePassAmount(String val){
    passAmount = val;
    notifyListeners();
  }
  savePassDuration(String val){
    passDuration = val;
    notifyListeners();
  }
  saveCurrentPassDuration(String val){
    currentPassDur = val;
    notifyListeners();
  }

}
class SplashScreen extends StatefulWidget {
   SplashScreen({Key? key,this.link}) : super(key: key);
  PendingDynamicLinkData? link;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserType()async{
    final val = await getUserType();
    String userT = val!['usertype'];
    print('test:$userT');
    context.read<FirstData>().saveUserType(userT);
    context.read<FirstData>().saveOriguser(userT);
  }
  getWalletDet()async{
    context.read<WalletDetails>().wallets.clear();
    final res = await walletDetails(context);
    final wallets = res['message']as List;
    for(var wallet in wallets){
      Wallet wal = Wallet(walletName: wallet['walletname'],
          walletNum: wallet['walletnumber'], currentBalance: wallet['actualBalance']);
     context.read<WalletDetails>().saveWallet(wal);
    }

  }
  Future <void> signin()async{

    UserType();
    getWalletDet();
    final prefs = await SharedPreferences.getInstance();
    context.read<FirstData>().getUserP(prefs.getString('userPic'));
    context.read<FirstData>().getUsername(prefs.getString('firstname'));
    if(prefs.getString('Origwynkid') == null){
      FocusScope.of(context).nearestScope;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
    }
    else {
      context.read<FirstData>().saveUniqueId(prefs.getString('Origwynkid'));
      final lPin = prefs.getString('mypin');

      try {
        Map loginResponse = await sendLoginDetails(pin: lPin!);
        if(loginResponse['statusCode'] != 200){
          showToast('There is a problem signing you in. Please sign in manually');
          Get.to(()=>
          const AnotherUserLogin(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
        }
        else{
          fullnameCont.text = loginResponse['name'];
          emailController.text = loginResponse['email'];
          confirmationPhoneCont.text = loginResponse['phone'];
          // prefs.setString('Origwynkid',loginResponse['username']);

          if(loginResponse['statusCode']==200){

            context.read<FirstData>().saveShowLoginNotif(true);
            print('transitioning');
            Get.to(()=>HomeMain14(),transition: Transition.circularReveal,duration: Duration(milliseconds: 500));}

          else if(loginResponse['statusCode']!=200){
            showToast('There is a problem signing you in. Please sign in manually');
            Get.to(()=>
            const AnotherUserLogin(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
          }
        }
      }
      catch(e) {
        showToast('There is a problem signing you in. Please sign in manually');
        Get.to(()=>
        const AnotherUserLogin(),transition: Transition.downToUp,duration: const Duration(seconds: 1));
      }
    }
  }

  @override
  void initState() {
    if(widget.link != null){
      print('link is: ${widget.link!.link}');
    }
    // TODO: implement initState
    super.initState();
    signin();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              child: Image.asset('lib/assets/images/wynkimage.png')),
          Positioned(
            bottom: 20.h,
            child: Center(
              child: Container(decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
                width: 150.w,
                child: Card(
                  elevation: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.h,),
                      SpinKitCircle(color: kYellow,),
                      SizedBox(height: 10.h,),
                      SizedBox(height: 10.h,),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

  }
}
