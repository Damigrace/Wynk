import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import 'package:intl/intl.dart';
import '../../utilities/widgets.dart';
import '../local_notif.dart';
import '../login_feature/another_user_login.dart';
import '../login_feature/login_page.dart';
import '../payments/dstv.dart';
import '../payments/gotv.dart';
import '../payments/internet_sub_main.dart';
import '../payments/mobile_recharge.dart';
import '../payments/request_funds/req_funds.dart';
import '../payments/send_funds/sendcash.dart';
import '../registration_feature/ride_online_map.dart';
import '../ride/ride_home.dart';
import '../vault/vault_home.dart';




class HomeMain14 extends StatefulWidget {
  const HomeMain14({Key? key}) : super(key: key);

  @override
  State<HomeMain14> createState() => _HomeMain14State();
}

class _HomeMain14State extends State<HomeMain14> {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  File? snappedP;
  Future <Uint8List?>getBytesFromAsset(String path, int width)async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }
  void saveInfos(BuildContext context)async{
    final originBitmap= await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/originmarker.png",
    );
    final carLocat= await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(100, 100)),
      "lib/assets/images/rides/car.png",
    );
    final Uint8List? mIk = await getBytesFromAsset('lib/assets/images/rides/car.png', int.parse(100.w.toString().split('.').first));
    context.read<FirstData>().saveCurMarker2(mIk!);
    context.read<FirstData>().saveStartMarker(originBitmap);
    final destBitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/assets/images/dest_donut.png",
    );
    context.read<FirstData>().saveCurMarker(carLocat);
    context.read<FirstData>().saveDestMarker(destBitmap);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    context.read<FirstData>().saveUser(drawerN!);
    context.read<FirstData>().saveUniqueId(prefs.getString('Origwynkid'));
    if(context.read<FirstData>().showLoginNotif == true){
      NotificationService.showNotif('WYNK Super App', 'You have been logged in $drawerN');
      context.read<FirstData>().saveShowLoginNotif(false);
    }
  }
  void initDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {

      handleDynamicLink(deepLink,context);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;

          if (deepLink != null) {
            handleDynamicLink(deepLink,context);
          }
        }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }
  handleDynamicLink(Uri url,BuildContext context) {

    Map queryParams = url.queryParameters;
    sendFundsVaultNumCont.text =  queryParams['vault'];
    sendFundsWynkid.text = queryParams['wynkid'];
    sendFundsAmountCont.text = queryParams['amount'];

    Get.to(()=>SendCash());


  }
  void getCapDet()async{
    Position currentLocation = await determinePosition(context);
    context.read<FirstData>().saveCurrentLocat(currentLocation.latitude, currentLocation.longitude);
  }
  void getCaptsAround(Position currentLocation )async{
    context.read<FirstData>().captains.clear();
   final res = await getCaptains(position:LatLng(
        currentLocation.latitude,
        currentLocation.longitude));
   if(res['statusCode'] == 201){
     showSnackBar(context,res['errorMessage']);
   }
   final caps = res['message']as List;
   for(var cap in caps){
     Marker captain = Marker(
       anchor: Offset(0.5,0.5),
       markerId: MarkerId('captain'),
       infoWindow: InfoWindow(title: 'Captain'),
       icon:BitmapDescriptor.fromBytes(context.read<FirstData>().curMarker2!),
       position:LatLng(double.parse(cap['latitude']),double.parse(cap['longitude'])),
     );
     context.read<FirstData>().saveCaps(captain);
   }
  }


  @override
  void initState() {
    getCapDet();
    refresh(context);
    initDynamicLinks(context);
    balanceFN = FocusNode();
    text=context.read<FirstData>().username?.toLowerCase();
    drawerN=text?.replaceFirst(text![0], text![0].toUpperCase());
    snappedP=context.read<FirstData>().providerImage;
    // TODO: implement initState
    super.initState();
    saveInfos(context);


  }

  File? imageFile;
  num vaultBalance=0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  FocusNode? balanceFN;
  String? text;
  String? drawerN;
  bool showBalance = true;
  int? picUploadMode;
  Icon icon = Icon(CupertinoIcons.eye_slash_fill);
  getPicture()async{
    XFile? pickedFile=await ImagePicker().pickImage(
        source: picUploadMode == 0?ImageSource.camera:ImageSource.gallery);
    if(pickedFile != null){
      imageFile=File(pickedFile.path);
      context.read<FirstData>().imageGotten(imageFile);
    }
  }
  userUmageAsString()async{
    File? uImage=context.read<FirstData>().providerImage;
    final bytes = await File(uImage!.path).readAsBytes();
    String userImg64 = base64Encode(bytes);
    return userImg64;
  }
   picturing(BuildContext context)async{
    BuildContext myC = this.context;
     showModalBottomSheet(
         enableDrag: false,
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
         ),
         context: context,
         builder: (context){
           return Container(
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
               ListTile(
                 leading:  CircleAvatar(
                     backgroundColor: kBlue,
                     child: Icon(Icons.camera_alt)),
                 title: Text('Take Photo'),
                 onTap: ()async{

                   Navigator.pop(context);
                   picUploadMode = 0;
                   spinner(myC);
                   final prefs = await SharedPreferences.getInstance();
                   await getPicture();
                   print('1');
                   String user64Img= await userUmageAsString();
                   print('2');
                   await savePicture(user64Img, prefs.getString('Origwynkid')!);
                   print('3');
                   showToast('Your profile picture has been successfully updated');
                   imageCache.clear();
                   imageCache.clearLiveImages();
                   Navigator.push(myC, MaterialPageRoute(builder: (context)=>const HomeMain14()));
                 },
               ),
               ListTile(
                 leading: CircleAvatar(
                     backgroundColor: kBlue,
                     child: Icon(Icons.folder)),
                 title: Text('Upload Photo'),
                 onTap: ()async{
                   Navigator.pop(context);
                   picUploadMode = 1;
                   spinner(myC);
                   final prefs = await SharedPreferences.getInstance();
                   await getPicture();
                   String user64Img= await userUmageAsString();
                   await savePicture(user64Img, prefs.getString('Origwynkid')!);
                   showToast('Your profile picture has been successfully updated');
                   imageCache.clear();
                   imageCache.clearLiveImages();
                   Navigator.push(myC, MaterialPageRoute(builder: (context)=>const HomeMain14()));
                 },
               )
             ],)
           );
         });

  }

   final channel = WebSocketChannel.connect(Uri.parse('wss://wynk.ng/stagging-api/picture/get-notification'));

  @override
  Widget build(BuildContext context) {
    String imageUrl = 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png';

    return WillPopScope(
      onWillPop: ()async{
        await showDialog(context: context, builder: (context){
        return AlertDialog(
          contentPadding: EdgeInsets.all(30.w),
          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 170.w,
                child: Text('Are you sure you want to logout?',
                  style: TextStyle(fontSize: 21.sp,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              ),
              GestureDetector(
                onTap:(){
                  Navigator.pop(context);
                  try{
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        LoginPage()), (Route<dynamic> route) => false);
                  }
                  catch(_){
                    context.read<FirstData>().saveVaultB('---');
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        AnotherUserLogin()), (Route<dynamic> route) => false);
                  }
                } ,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top:30.h),
                  height: 51.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.black)
                  ),
                  child: Center(
                    child: Text('Yes, Log Out',
                        style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600)),
                  ),
                ),),
              GestureDetector(
                onTap: (){Navigator.pop(context);},
                child: Container(
                  margin: EdgeInsets.only(top:10.h),
                  width: MediaQuery.of(context).size.width,
                  height: 51.h,
                  decoration: BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text('No, Back to homepage',
                      style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                  ),
                ),)
            ],
          ),
        );});
        return false;},

      child: Scaffold(backgroundColor: Colors.white,
        key: _key,
        drawer:  Drawer(
          width: 250.w,
          child: DrawerWidget(),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 70.w,
          leading:Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: GestureDetector(
              onTap: () {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    contentPadding: EdgeInsets.all(3.h),
                    content: Stack(
                      children: [
                        Image.network(imageUrl ,
                          key: ValueKey(Random().nextInt(100)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: kBlue,
                            child:IconButton(
                              icon:  Icon(Icons.camera_alt),
                              onPressed: ()async{
                                context.read<FirstData>().saveUniqueId(context.read<FirstData>().uniqueId);
                                await picturing(context);
                              },
                            ),),
                        )
                      ],
                    ),
                  );});

              },
              child:
              // snappedP==null?CircleAvatar(
              //   child: Text(text!.toUpperCase().substring(0,2),style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
              // ):
              // CircleAvatar(backgroundImage: NetworkImage( context.read<FirstData>().profImgUrl!),)
              CircleAvatar(
                backgroundColor: kBlue,
                  child: CircleAvatar(backgroundImage:
                  NetworkImage( 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png'),),)
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap:  () { _key.currentState!.openDrawer();},
                child: Image.asset('lib/assets/menu.webp'),
              )
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: context.read<FirstData>().activeRide,
          child: GestureDetector(
            onTap: (){
              context.read<FirstData>().activeRide?{
                context.read<FirstData>().userType == '3'?
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) =>
              GMapWebview(
                  destination:LatLng(
                      context.read<FirstData>().endPos!.geometry!.location!.lat!,
                      context.read<FirstData>().endPos!.geometry!.location!.lng!),
              ))):Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) =>
                  GMapWebview(
                    destination:context.read<RideDetails>().destPos!
                  )))
              }:showSnackBar(context, 'You do not have an active ride');
            },
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: kYellow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.keyboard_return),
                  Text('Ride')
                ],
              )
            ),
          ),
        ),
        body: SafeArea(
          child:Padding(
              padding:  EdgeInsets.only(left: 15.w,right: 15.w),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.watch<FirstData>().userType == '2'?'Capt. ${
                            context.watch<FirstData>().user}'
                            :context.watch<FirstData>().user??'',style: TextStyle(fontSize: 20.sp)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8.h),
                              width: 147.w,height:15.h,
                              child: TextField(
                                focusNode: balanceFN,
                            textAlign: TextAlign.end,
                            style:TextStyle(color: kBlue,fontSize: 18.sp,fontWeight: FontWeight.w600) ,
                            obscureText: showBalance,
                            obscuringCharacter: '*',
                            decoration: InputDecoration.collapsed(hintText: ''),
                            readOnly: true,
                            controller: accountBalCont,
                            ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      constraints: BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: icon,onPressed: (){
                                    setState(() {
                                      showBalance = !showBalance;
                                      showBalance == true?icon=Icon(CupertinoIcons.eye_slash_fill):icon=Icon(CupertinoIcons.eye_fill);
                                    });
                                  }),
                                  SizedBox(width: 10.w,),
                                  Text( 'Vault Balance',style:TextStyle(color: Colors.black87,fontSize: 18.sp))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],),
                  ),
                  Expanded  (
                    flex: 10,
                    child:SingleChildScrollView(
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(left: 8.w,bottom: 11.h),
                            child: Text('Get Started',style: kTextStyle5,),
                          ),
                          SizedBox(
                              height: 150.h,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                      child: Image.asset('lib/assets/images/functions/ride.png'),
                                  onTap: () async{
                                        print(context.read<FirstData>().userType!);
                                  try  {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context, builder: (context){
                                      return Container(child:
                                      SpinKitCircle(
                                        color: kYellow,
                                      ),);
                                    });
                                      Position currentLocation = await determinePosition(context);
                                      context.read<FirstData>().saveCurrentLocat(currentLocation.latitude, currentLocation.longitude);
                                      Navigator.pop(context);
                                      if(context.read<FirstData>().userType! == '2'){
                                        Navigator.pushNamed(context, '/CaptainHome');
                                      }
                                     else {
                                        getCaptsAround(currentLocation);
                                       Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RideHome()));}
                                    }
                                    catch(e){print(e);}
                                  },),
                                  SizedBox(width: 7.w,),
                                  GestureDetector(
                                      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                          VaultHome())),
                                      child: Image.asset('lib/assets/images/functions/my vault.png')),
                                  SizedBox(width: 7.w,),
                                  GestureDetector(
                                      onTap: ()=> Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InternetSubMain())),
                                      child: Image.asset('lib/assets/images/functions/subscriptions.png',height: 200,)),
                                  SizedBox(width: 7.w,),
                                  GestureDetector(
                                      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                          SendCash())),
                                      child: Image.asset('lib/assets/images/functions/send_funds-removebg-preview (1).png')),
                                  SizedBox(width: 7.w,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                            RequestFunds()));
                                      },
                                      child: Image.asset('lib/assets/images/functions/request_funds-removebg-preview (1).png')),
                                  SizedBox(width: 7.w,),
                                  GestureDetector(
                                      onTap: ()async{
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                            MobileRecharge()));
                                      },
                                      child: Image.asset('lib/assets/images/functions/top_up.png',)),
                                  SizedBox(width: 7.w,),
                                  GestureDetector(
                                      onTap:() =>showSnackBar(context,'This is not available yet'),
                                      child: Image.asset('lib/assets/images/functions/foodie.png')),
                                  SizedBox(width: 7.w,),
                                  GestureDetector(
                                      onTap:() =>showSnackBar(context,'This is not available yet'),
                                      child: Image.asset('lib/assets/images/functions/delivery.png')),
                                ],
                              )),
                          Padding(
                            padding:  EdgeInsets.only(left: 8.w,top: 17.h,bottom: 11.h),
                            child: Text('Quick Pay',style: kTextStyle5,),
                          ),
                          SizedBox(
                              height: 150.h,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                GestureDetector(
                                    onTap:(){
                                      context.read<FirstData>().saveSelNet(1);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MobileRecharge()));
                                    },
                                    child: Image.asset('lib/assets/images/quick_pay/image-6-1@1x.png')),
                                  SizedBox(width: 7.w,),
                                  GestureDetector(
                                      onTap: (){
                                        context.read<FirstData>().saveSelNet(2);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MobileRecharge()));
                                      },
                                      child: Image.asset('lib/assets/images/quick_pay/image-9-1@1x.png')),
                                  SizedBox(width: 7.w,),

                                  GestureDetector(
                                      onTap: (){

                                        context.read<FirstData>().saveSelNet(3);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MobileRecharge()));
                                      },
                                      child: Image.asset('lib/assets/images/quick_pay/image-7-1@1x.png')),
                                  SizedBox(width: 7.w,),
                                  GestureDetector(
                                      onTap: (){
                                        context.read<FirstData>().saveSelNet(4);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MobileRecharge()));
                                      },
                                      child: Image.asset('lib/assets/images/quick_pay/image-8-1@1x.png')),
                                  SizedBox(width: 7.w,),
                                GestureDetector(
                                    onTap: ()=>Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DSTV())),
                                    child: Image.asset('lib/assets/images/quick_pay/image-10-1@1x.png')),
                                  SizedBox(width: 7.w,),
                                GestureDetector(
                                    onTap: ()=>Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GOTV())),
                                    child: Image.asset('lib/assets/images/quick_pay/image-11-1@1x.png')),
                                  SizedBox(width: 7.w,),
                                GestureDetector(
                                    onTap: ()=>showSnackBar(context, 'This is not available yet'),
                                    child: Image.asset('lib/assets/images/quick_pay/image-12-1@1x.png')),
                                  SizedBox(width: 7.w,),
                                GestureDetector(
                                    onTap: ()=>showSnackBar(context, 'This is not available yet'),
                                    child: Image.asset('lib/assets/images/quick_pay/image-13-1@1x.png')),
                                ],
                              )),
                          Padding(
                            padding:  EdgeInsets.only(left: 8.w,top: 17.h,bottom: 11.h),
                            child: Text('Discover Wynk',style: kTextStyle5,),
                          ),
                          Opacity(
                            opacity: 0.4,
                            child: SizedBox(
                                height: 150.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    WynkDCont('lib/assets/images/discover_wynk/direct-deposit-11x.png'),
                                    WynkDCont('lib/assets/images/discover_wynk/teen-banking-1@1x.png'),
                                    WynkDCont('lib/assets/images/discover_wynk/wynk-points-1@1x.png'),
                                    WynkDCont('lib/assets/images/discover_wynk/coorpcar.png'),
                                    WynkDCont('lib/assets/images/discover_wynk/promos-11x (2).png'),
                                    WynkDCont('lib/assets/images/discover_wynk/ambassador.png')
                                  ],
                                )),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left: 8.w,top: 17.h,bottom: 11.h),
                            child: Text('Discounts and Promotions',style: kTextStyle5,),
                          ),
                          Opacity(
                            opacity: 0.4,
                            child: SizedBox(
                                height: 150.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    GestureDetector(
                                        onTap:()async{
                                          getCharges();
                                          //infobipVoiceCall();
                                         // multiChoiceLookup('DSTV');

                                        // final res = await pdf();
                                        //  final output = await getExternalStorageDirectory();
                                        //  final file = File('${output!.path}/invoice.pdf');
                                        //  if(await file.exists()){
                                        //  print(file.path);
                                        //  await file.writeAsBytes(res);
                                        //  }
                                        //  else{
                                        //    print('dir. does not exist');
                                        //    print(file.path);
                                        //    await file.create(recursive: true);
                                        //    await file.writeAsBytes(res);
                                        //  }
                                        //   Uint8List? green;
                                        //   Uint8List? red;
                                        //
                                        //     final ByteData bytes = await rootBundle.load('lib/assets/images/dest_donut.png');
                                        //     green = bytes.buffer.asUint8List();
                                        //     final ByteData bytes1 = await rootBundle.load('lib/assets/images/dest_donut.png');
                                        //     red = bytes1.buffer.asUint8List();
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               TandC()));

                                          // String appleUrl = 'https://maps.apple.com/?saddr=&daddr=5,7&directionsmode=driving';
                                          // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=-3.8232,-38.481700';
                                          //
                                          //
                                          // if (Platform.isAndroid) {
                                          //   if (await canLaunchUrl(Uri.parse(googleUrl))) {
                                          //     await launchUrl(Uri.parse(googleUrl));
                                          //   } else {
                                          //     if (await canLaunchUrl(Uri.parse(appleUrl))) {
                                          //       await launchUrl(Uri.parse(appleUrl));
                                          //     } else {
                                          //       throw 'Could not open the map.';
                                          //     }
                                          //   }
                                          // } else {
                                          //   if  (await canLaunchUrl(Uri.parse(googleUrl))) {
                                          //     await launchUrl(Uri.parse(googleUrl));
                                          //   } else {
                                          //     throw 'Could not open the map.';
                                          //   }
                                          // }
                                        },
                                        child: Discounts(image: Image.asset('lib/assets/images/discounts/item1.png'), itemDescription: 'Vegan Salad with Kebab and sauce',)),
                                    Discounts(image: Image.asset('lib/assets/images/discounts/item2.png'), itemDescription: 'Chocolate bar with Cream',),
                                    Discounts(image: Image.asset('lib/assets/images/discounts/item3.png'), itemDescription: 'Special Salmon Fish Sauce',),
                                  ],
                                )),
                          ),
                          SizedBox(height:10.h ,)
                        ],),
                    ))
            ],)
          ) ,
        ),
      ),
    );
  }
}

class WynkDCont extends StatelessWidget {
String image;
  WynkDCont(this.image);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.asset(image,scale: 0.8,),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black,width: 0),
      borderRadius: BorderRadius.circular(18)
    ),
    margin: EdgeInsets.only(right: 10.w,left: 2.w),);
  }
}

class FunctionsTile extends StatelessWidget {
String title;
Image image;
Color color;

FunctionsTile({required this.title, required this.image,required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:7.w ),
      decoration: BoxDecoration(
          color: color,
        borderRadius: BorderRadius.circular(10)
      ),
        width: 115.h,height: 119.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            SizedBox(height: 11.h,),
            Text(title,style: TextStyle(fontSize: 15.sp,color: Colors.white),)
          ],
        ));
  }
}



class QuickPayile extends StatelessWidget {

  Image image;
 QuickPayile({Key? key,  required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal:4.w ),
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        width: 115.h,height: 123.h,
        child: image);
  }
}


class DiscoverWynk extends StatelessWidget {

  Image image;
  DiscoverWynk({Key? key,  required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal:4.w ),
        decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(7)
        ),
        width: 206.w,height: 149.h,
        child: image);
  }
}

class Discounts extends StatelessWidget {
  String itemDescription;
  Image image;
  Discounts({Key? key,  required this.image,required this.itemDescription}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal:4.w ),
        decoration: BoxDecoration(
          border:Border.all(color: kGrey1,width: 0.5.w),
            color:Colors.white30,
            borderRadius: BorderRadius.circular(7)
        ),
        width: 206.w,height: 149.h,
        child: Column(children: [
          Flexible(
              flex: 5,
              child: image),
          Flexible(
              flex: 2,
              child:Container(
                padding:EdgeInsets.symmetric(horizontal: 10.w),
                child: Center(
                child:Text(itemDescription) ,),))
        ],));
  }
}