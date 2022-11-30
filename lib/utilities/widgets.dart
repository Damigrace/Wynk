import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../controllers.dart';
import '../features/landing_pages/home_main14.dart';
import '../features/login_feature/another_user_login.dart';
import '../features/login_feature/login_page.dart';
import '../features/ride/ride_history_invoice.dart';
import '../features/ride_schedule/my_bookings.dart';
import '../features/setups/settings.dart';
import '../features/transaction_history.dart';
import '../features/wynk-pass/no_pass_screen.dart';
import '../features/wynk-pass/pass_status.dart';
import '../features/wynk-pass/wynk_pass_confirmation.dart';
import '../features/wynk-pass/wynk_prepaid.dart';
import '../main.dart';
import '../services.dart';
import 'constants/colors.dart';
import 'constants/textstyles.dart';
import 'package:url_launcher/url_launcher.dart';
backButton(BuildContext context){
  return Container(height: 36.h,width: 36.h,
    decoration: BoxDecoration(
        color: kBlue,
        borderRadius: BorderRadius.circular(5)
    ),
    child: GestureDetector(
      child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 30.w,),
      onTap: ()=>Navigator.pop(context),
    ),
  );
}
void spinner(BuildContext context){
  showDialog(
      barrierDismissible: false,
      context: context, builder: (context){
    return Container(child:
    SpinKitCircle(
      color: kYellow,
    ),);
  });
}
class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class BanksModel{
  String? bankName;
  String? bankCode;

  BanksModel({required this.bankName, required this.bankCode});

}

class _DrawerWidgetState extends State<DrawerWidget> {

  void logoutConf(){
    try{
      showDialog(context: context, builder: (context){
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
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pop(context);},
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
        );});}
    catch(_){Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        AnotherUserLogin()), (Route<dynamic> route) => false);};
  }
  void gotoPassStat(BuildContext context)async{
    showDialog(context: context, builder: (context){
      return Container(child:
      SpinKitCircle(
        color: kYellow,
      ),);
    });
      final passStatus = await getCurrentPass();
      if(passStatus['statusCode'] == 200){
        context.read<PassSubDetails>().savePassName(passStatus['pass_name']);
        context.read<PassSubDetails>().saveCurrentPassDuration(passStatus['date']);
        context.read<PassSubDetails>().saveCurrPassType(passStatus['pass_type']);
        final passNum = await passDetail();
        context.read<PassSubDetails>().prepaidPasses.clear();
        context.read<PassSubDetails>().postpaidPasses.clear();
        final passes = passNum['message'] as List;
        for(Map<String, dynamic> pass in passes){
          WhiteWynkPass passModel = WhiteWynkPass(
            subType: 'post-paid',
            amount: pass['amount'],
            passName: pass['pass_name'],
            passId: pass['pass_id'],
            duration: pass['duration'],);
          print(pass['pass_type'] );
          if(pass['pass_type'] == '1'){context.read<PassSubDetails>().savePrepaidPass(passModel);}
          if(pass['pass_type'] == '2'){context.read<PassSubDetails>().savePostpaidPass(passModel);}
        }
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PassStatus()));}
      else{
        final passNum = await passDetail();
        context.read<PassSubDetails>().prepaidPasses.clear();
        context.read<PassSubDetails>().postpaidPasses.clear();
        final passes = passNum['message'] as List;
        for(Map<String, dynamic> pass in passes){
          WhiteWynkPass passModel = WhiteWynkPass(
            subType: 'post-paid',
            amount: pass['amount'],
            passName: pass['pass_name'],
            passId: pass['pass_id'],
            duration: pass['duration'],);
          print(pass['pass_type'] );
          if(pass['pass_type'] == '1'){context.read<PassSubDetails>().savePrepaidPass(passModel);}
          if(pass['pass_type'] == '2'){context.read<PassSubDetails>().savePostpaidPass(passModel);}
        }
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoPassStatus()));
      }

  }

  getRides()async{
    context.read<FirstData>().rides.clear();
    showDialog(
        barrierDismissible: false,
        context: context, builder: (context){
      return Container(child:
      SpinKitCircle(
        color: kYellow,
      ),);});
    final res =await  capRideHist();
    if (res['statusCode'] == 201){
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar(context, 'You do not have a ride history yet. Please take a ride.');
    }
    else{
    final rides = res['message'] as List;
    for(var ride in rides){
      print('${ride['destination']}');
      RideDetail rideDetail = RideDetail(
        from: ride['pick_up'],
        to: ride['destination'],
        date: ride['pickup_date'],
        patName: ride['patron_name'],
        amount: ride['amount'],
        pickupLat: double.parse(ride['start_lat']),
        pickupLong: double.parse(ride['start_long']),
        destLat: double.parse(ride['end_lati']),
        destLong: double.parse(ride['end_longi']),
        patWynkid: ride['patron_wynkid'],);
      context.read<FirstData>().saveRideDetail(rideDetail);
    }
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(context, '/RidesList');}
  }
  Future<void> captDrawerItem(int index) async {
    print(index);
    switch(index){
      case 0 :  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          HomeMain14()), (Route<dynamic> route) => false);
      break;
      case 6 : Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          Settings()));
      break;
      case 7: Navigator.pop(context);showDialog(
          barrierDismissible: false,
          context: context, builder: (context){
        return AlertDialog(
          title: Text('Support'),
            contentPadding: EdgeInsets.all(30.w),
            shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)
            ),
            content: Container(
              width: 301.w,
              height:270.h,
              child: Column(
                children: [
                  Text('This version of the app is an MVP. You can reach the support team by sending a whatsapp message to any contact below.'),
                  TextButton(
                      onPressed:(){ launchUrl(Uri.parse('whatsapp://send?phone=+2348106052329&text=Hello Dami'));},
                      child:Text('Contact 1')),
                  TextButton(
                      onPressed:(){ launchUrl(Uri.parse('whatsapp://send?phone=+2348035538658&text=Hello Olumide'));},
                      child:Text('Contact 2')),
                ],
              )
            ));});
      break;
      case 1 : getRides();
      break;
      case 2 : Navigator.pop(context); Navigator.pushNamed(context, '/Payments');
      break;
      case 3 :  Navigator.pop(context); Navigator.pushNamed(context, '/UserSelector'); break;
      case 10:
        logoutConf();
        break;
      case 4 :Navigator.pop(context); Navigator.pushNamed(context, '/VaultHome');
      break;
      case 5 :
      spinner(context);
      context.read<FirstData>().transcards.clear();
      final response = await transHist();
      if(response['statusCode'] == 200){
        List res = response['message'];
        res.forEach((element) {
          if(element['products'] == 'w2b'){

            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/functions/send_funds-removebg-preview (1).png')),
              title: Text('Funds sent to ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'w2w'){
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/wynkimage.png')),
              title: Text('Funds sent to ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'ride'){
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/rides/economy.png')),
              title: Text('A  Ride with ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'airtime'){
            String? image;
            switch(element['channel']){
              case  'MTN': image = 'lib/assets/images/quick_pay/image-6-1@1x.png';break;
              case  '9 Mobile': image = 'lib/assets/images/quick_pay/image-9-1@1x.png';break;
              case  'GLO': image = 'lib/assets/images/quick_pay/image-7-1@1x.png';break;
              case  'Airtel': image = 'lib/assets/images/quick_pay/image-8-1@1x.png';break;
            }
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset(image!) ),
              title: Text('Airtime Purchase for ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'power'){
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/payments/elec.png')),
              title: Text('Power Purchase for ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'cable'){
            String? image;
            switch(element['channel']){
              case  'GOTV': image = 'lib/assets/images/gotv.png';break;
              case  'DSTV': image = 'lib/assets/images/dstv.png';break;

            }
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset(image!)),
              title: Text('Cable Subscription for ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'smile'){
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/subscriptions/smile.jpg')),
              title: Text('Smile Data Purchase for ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
        });
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>TransHistory()),);
      }

      else{
        showSnackBar(context, response['errorMessage']);
        Navigator.pop(context);
      }
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          TransHistory())); break;
      case 9:
          gotoPassStat(context);
        break;
      case 11:
        spinner(context);
        final pos = await determinePosition(context);
        await onlineStatus(0, LatLng(pos.latitude, pos.longitude));
        Navigator.pop(context);
        Navigator.pop(context);
        showSnackBar(context, 'You are now offline. Return to Captain Home to go online.');
        break;

    }
  }
  Future<void> patDrawerItem(int index) async {
    print(index);
    switch(index){
      case 0 :  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          HomeMain14()), (Route<dynamic> route) => false);
      break;
      case 1 : getRides();
      break;
      case 6 : Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      MyBookingsMVP()));
      break;
      case 7 : Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          Settings()));
      break;
      case 2 : Navigator.pop(context); Navigator.pushNamed(context, '/Payments');
      break;
      case 3 :  Navigator.pop(context); Navigator.pushNamed(context, '/UserSelector'); break;
      case 5 :  spinner(context);
      context.read<FirstData>().transcards.clear();
      final response = await transHist();
      if(response['statusCode'] == 200){
        List res = response['message'];
        res.forEach((element) {
          if(element['products'] == 'w2b'){

            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/functions/send_funds-removebg-preview (1).png')),
              title: Text('Funds sent to ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'w2w'){
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/wynkimage.png')),
              title: Text('Funds sent to ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'ride'){
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/rides/economy.png')),
              title: Text('A  Ride with ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'airtime'){
            String? image;
            switch(element['channel']){
              case  'MTN': image = 'lib/assets/images/quick_pay/image-6-1@1x.png';break;
              case  '9 Mobile': image = 'lib/assets/images/quick_pay/image-9-1@1x.png';break;
              case  'GLO': image = 'lib/assets/images/quick_pay/image-7-1@1x.png';break;
              case  'Airtel': image = 'lib/assets/images/quick_pay/image-8-1@1x.png';break;
            }
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset(image!) ),
              title: Text('Airtime Purchase for ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'power'){
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/payments/elec.png')),
              title: Text('Power Purchase for ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'cable'){
            String? image;
            switch(element['channel']){
              case  'GOTV': image = 'lib/assets/images/gotv.png';break;
              case  'DSTV': image = 'lib/assets/images/dstv.png';break;

            }
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset(image!)),
              title: Text('Cable Subscription for ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
          else if(element['products'] == 'smile'){
            var iniListTile = ListTile(
              contentPadding: EdgeInsets.only(left: 36.w),
              onTap: (){

              },
              leading: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: Image.asset('lib/assets/images/subscriptions/smile.jpg')),
              title: Text('Smile Data Purchase for ${element['customer']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
              subtitle: Text('${element['created_date']}'),
              trailing: Text('${element['amount']}',style: TextStyle(fontSize: 22.sp,)),
            );
            context.read<FirstData>().saveTransCard(iniListTile);
          }
        });
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>TransHistory()),);
      }

      else{
        showSnackBar(context, response['errorMessage']);
        Navigator.pop(context);
      }
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          TransHistory())); break;
     // case 8: gotoPassStat(context);break;
      case 7 : Navigator.pop(context); Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          MyBookingsMVP()));
      break;
      case 10:
        logoutConf();
        break;
      case 4 :Navigator.pop(context); Navigator.pushNamed(context, '/VaultHome');
      break;
      // case 7:
      //   gotoPassStat(context);
      //   break;

    }
  }
  Icon icon = Icon(CupertinoIcons.eye_slash_fill);
  bool showBalance = true;
  @override
  Widget build(BuildContext context) {

    List<String> capDrawerItemsList=[
      'Home',
      'Rides',
      'Payments',
      'WynkSwitch',
      'My Vault',
      'Transaction History',
      'Settings',
      'Support',
      'Terms & Conditions',
      'Pass Status',
      'Log Out',
      'Go Offline'
    ];
    List<String>patDrawerItemsList=[
      'Home',
      'Rides',
      'Payments',
      'WynkSwitch',
      'My Vault',
      'Transaction History',
      'My Bookings',
      'Settings',
      'Support',
      'Terms & Conditions',
      'Log Out',

    ];

    return Column(
      children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150.w,
              height: 120.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 26.r,backgroundColor: kBlue,
                    child:CircleAvatar(backgroundImage:
                    NetworkImage( 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png'),),
                  ),
                  Text(context.watch<FirstData>().userType == '2'?'Capt. ${
                      context.watch<FirstData>().user}'
                      :context.watch<FirstData>().user??'User',style: TextStyle(fontSize: 20.sp))
                ],
              ),
            ),
            SizedBox(height: 10.h,),
            Container(
              width: 147.w,height:25.h,
              child: TextField(
                textAlign: TextAlign.start,
                style:TextStyle(color: Colors.green,fontSize: 18.sp) ,
                obscureText: showBalance,
                obscuringCharacter: '*',
                decoration: InputDecoration.collapsed(hintText: ''),
                readOnly: true,
                controller: accountBalCont,
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(bottom: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: IconButton(
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: icon,onPressed: (){
                      setState(() {
                        showBalance = !showBalance;
                        showBalance == true?icon=Icon(CupertinoIcons.eye_slash_fill):icon=Icon(CupertinoIcons.eye_fill);
                      });
                    }),
                  ),
                  SizedBox(width: 10.w,),
                  Text( 'Vault Balance',style:TextStyle(color: Colors.black87,fontSize: 18.sp))
                ],
              ),
            ),
          ],),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 18.w),
          color: Colors.white54,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount:context.read<FirstData>().userType == '2'? capDrawerItemsList.length:patDrawerItemsList.length,
            itemBuilder: (context,index)=>ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: (){
                context.read<FirstData>().userType == '2'?
                captDrawerItem(index):patDrawerItem(index);
              },
              leading: context.read<FirstData>().userType == '2'? Text(capDrawerItemsList[index],
                style: TextStyle(fontSize: 18.sp),):Text(patDrawerItemsList[index],
                style: TextStyle(fontSize: 18.sp),)
            ),),
        ),
      )
    ],);
  }
}

class AddTypeInputBox extends StatelessWidget {
 String? hintText;
 TextEditingController controller;
 TextInputType textInputType;
 bool? readonly;
 VoidCallback function;
AddTypeInputBox({Key? key,  required this.hintText,required this.controller,required this.textInputType,this.readonly,required this.function}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Material(
          borderRadius: BorderRadius.circular(7),
          elevation: 3,
          child: Container(
              height: 61.h,
              width: double.infinity,
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                      color: kGrey1),
                  color: kWhite),
              child:Row(children: [
                SizedBox(width: 18.w,),
                Expanded(
                  child: TextField(
                    readOnly: readonly??true,
                    onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                    autofocus: true,
                    keyboardType:textInputType,
                    style: kTextStyle5,
                    decoration:   InputDecoration.collapsed(
                        hintText: hintText,
                        hintStyle: const TextStyle(fontSize: 15,
                            color: kBlack1
                        )),
                    controller: controller,),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white
                    ),
                    onPressed:function, child: const Text('Upload Image',style:TextStyle(color: Color(0xff0e0e24)) ,)),
                SizedBox(width: 10.w,)
              ],
              )
          ),
        ));
  }
}
class InputBox extends StatelessWidget {
  int? maxLine;
  String? hintText;
  TextEditingController controller;
  TextInputType textInputType;
  int? flex;
  InputBox({Key? key,  required this.hintText,required this.controller,required this.textInputType,this.flex,this.maxLine}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex??1,
        child:  Container(
            height: 61.h,
            width: double.infinity,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: kGrey1),
                color: kWhite),
            child:Row(children: [
              SizedBox(width: 18.w,),
              Expanded(
                child: TextField(maxLines:maxLine ,
                  onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                  autofocus: true,
                  keyboardType:textInputType,
                  cursorColor: kBlue,
                  style: kTextStyle5,
                  decoration:   InputDecoration.collapsed(
                      hintText: hintText,
                      hintStyle: const TextStyle(fontSize: 15,
                          color: kBlack1
                      )),
                  controller: controller,),
              )
            ],
            )
        ));
  }
}
class FlexlessInputBox extends StatelessWidget {
  int? maxLine;
  String? hintText;
  TextEditingController controller;
  TextInputType textInputType;
  bool? shouldObscure;
  FlexlessInputBox({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.textInputType,
    this.shouldObscure,
    this.maxLine}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 22.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        height: 61.h,
        width: 326.w,
        decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
                color: kGrey1),
            color: kWhite),
        child:Align(
          alignment: Alignment.center,
          child: TextField(
            maxLines:1 ,
            cursorHeight: 0,
            cursorWidth: 0,
            onEditingComplete:()=> FocusScope.of(context).nextFocus(),
            obscureText: shouldObscure??false,
            minLines: maxLine??1,
            autofocus: true,
            keyboardType:textInputType,
            style: TextStyle(fontSize: 22.sp,),
            decoration:   InputDecoration.collapsed(
                hintText:  hintText,
                hintStyle:  TextStyle(fontSize: 22.sp,
                    color: kBlack1
                )),
            controller: controller,),
        )
    );
  }
}
class ElevatedInputBox extends StatelessWidget {
  String? hintText;
  TextEditingController controller;
  TextInputType textInputType;
  int? flex;
  ElevatedInputBox({Key? key,  required this.hintText,required this.controller,required this.textInputType,this.flex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex??1,
        child:  Material(
          borderRadius: BorderRadius.circular(7),
          elevation: 4,
          child: Container(
              height: 61.h,
              width: double.infinity,
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                      color: kGrey1),
                  color: kWhite),
              child:Row(children: [
                SizedBox(width: 18.w,),
                Expanded(
                  child: TextField(
                    onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                    autofocus: true,
                    keyboardType:textInputType,
                    style: kTextStyle5,
                    decoration:   InputDecoration.collapsed(
                        hintText: hintText,
                        hintStyle: const TextStyle(fontSize: 15,
                            color: kBlack1
                        )),
                    controller: controller,),
                )
              ],
              )
          ),
        ));
  }
}
class readOnlyInputBox extends StatefulWidget {
  String? hintText;
  TextEditingController controller;

  readOnlyInputBox({Key? key,  required this.hintText,required this.controller}) : super(key: key);

  @override
  State<readOnlyInputBox> createState() => _readOnlyInputBoxState();
}

class _readOnlyInputBoxState extends State<readOnlyInputBox> {


  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
            height: 61.h,
            width: double.infinity,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: kGrey1),
                color: kWhite),
            child:Row(children: [
              SizedBox(width: 18.w,),
              Expanded(
                child: TextField(
                  readOnly: true,
                  onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                  autofocus: true,
                  style: kTextStyle5,
                  decoration:   InputDecoration.collapsed(
                      hintText: widget.hintText,
                      hintStyle: const TextStyle(fontSize: 15,
                          color: kBlack1
                      )),
                  controller: widget.controller,),
              )
            ],
            )
        ));
  }
}

class Rides extends StatefulWidget {
  String image;
  String title;
  String time;
  String price;
  Color color;
  Rides({required this.image,required this.time,required this.title,required this.price,required this.color});

  @override
  State<Rides> createState() => _RidesState();
}
int groupValue=0;
class _RidesState extends State<Rides> {

  rideChoice(String title){

    switch(title){
      case 'Economy': print(1);
      showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
          ),
          context: context,
          builder: (context){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.only(top: 33.h,left: 17.w,right: 17.w),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset('lib/assets/images/rides/handledown.png',width: 57.w,height: 12.h,),
                      SizedBox(height: 22.h,),
                      Rides(
                        image: 'lib/assets/images/rides/economy.png',
                        title: 'Economy',
                        time: '10:20 Dropoff',
                        price: '₦ 700 - ₦ 1,100', color: Color(0xffF7F7F7),),
                      SizedBox(height: 21.h,),
                      Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                      SizedBox(
                        child: Container(
                          padding: EdgeInsets.only(top: 17.h),
                          width: double.infinity,
                          child: Row(children: [
                            Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                            SizedBox(width: 18.w,),
                            SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),)),
                            Radio<int>(value: 1, groupValue: groupValue, onChanged: (value){
                              setState(() {
                                groupValue=value!;
                              });
                            })
                          ],),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 0.h),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('lib/assets/images/rides/wynkcash.png',height: 26.w,width: 26.w,),
                            SizedBox(width: 18.w,),
                            SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),)),
                            Radio<int>(value: 2, groupValue: 0, onChanged: (value){
                              setState(() {
                                groupValue=value!;
                              });
                            })
                          ],),
                      ),
                      SizedBox(height: 18.h,),
                    ],),),
              ],
            );
          });
      break;
    }switch(title){
      case 'Sedan': print(2);
      break;
    }switch(title){
      case 'Taxi': print(3);
      break;
    }switch(title){
      case 'Moto': print(4);
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: widget.color,
      child: Row(children: [
        Image.asset(widget.image,width: 201.w,height: 109.h,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,style: TextStyle(fontSize: 18.sp)),
            SizedBox(height: 5.h,),
            Text(widget.time,style: TextStyle(fontSize: 12.sp),),
            SizedBox(height: 13.h,),
            Text(widget.price,style: TextStyle(fontSize: 18.sp),)
          ],)
      ],),
    );
  }
}
class UserTopBar extends StatelessWidget {
  const UserTopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          child: ClipRect(child: Image.asset('lib/assets/images/wynkimage.png',scale: 7,)),
        ),
        title: Text('Cpt. Adeola!',style: TextStyle(fontSize: 23.sp),),
        trailing:backButton(context)
    );
  }
}


class DetailsTile extends StatelessWidget {

   String title;
   IconData icondata;
   TextEditingController controller;
   DetailsTile({required this.icondata,required this.title, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left:25.w,top: 26.h ,right: 24.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: kTextStyle4,),
            SizedBox(height: 7.h),
            TextField(

              enabled:  false,
              style: kTextStyle5,
              decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: EdgeInsets.only(bottom:11.h,right: 11.w),
                    height: 10.w,
                    width: 10.w,
                    padding: EdgeInsets.all(5.sp),
                    decoration: BoxDecoration(
                        color: kBlue,
                        borderRadius: BorderRadius.circular(7)
                    ),
                    child: Icon(icondata,color: Colors.white,size: 21.sp,),
                  )
              ),
              controller: controller,)
          ],),
      ),
    );
  }
}
class UserProfileHeader extends StatelessWidget {
   UserProfileHeader({
    this.name,
    Key? key,
  }) : super(key: key);
String? name;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 59.h,
      left: 18.w,
      child: Container(
        height: 88.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 26.r,
              backgroundColor: kBlue,
              child:CircleAvatar(backgroundImage: NetworkImage( 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png')),
            ),
            Text(context.watch<FirstData>().userType == '2'?'Capt. ${
                context.watch<FirstData>().user}'
                :context.watch<FirstData>().user??'User',style: TextStyle(fontSize: 20.sp))
          ],
        ),
      ),
    );
  }
}
class Wallet extends StatelessWidget {

  String? walletName;
  String? walletNum;
  String? currentBalance;
  String? actualBalance;

  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");

  Wallet({Key? key,required this.walletName,required this.walletNum,required this.currentBalance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bal = currentBalance ==''?'---':currentBalance! ;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          minLeadingWidth: 0,
          contentPadding: EdgeInsets.zero,
          title: Text(walletName!),
          subtitle: Text(walletNum!),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('₦$bal',style: TextStyle(fontSize: 18.sp,color: kYellow,fontWeight: FontWeight.w600),),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}

class RideDetail extends StatelessWidget {

  String? from;
  String? to;
  String? date;
//  String? pickUp;
//  String? destination;
  String? patName;
  String? patPlate;
  String? amount;
  String? patWynkid;
  double? pickupLat;
  double? pickupLong;
  double? destLat;
  double? destLong;
  RideDetail({Key? key,
    required this.from,
    required this.to,
    required this.date,
    required this.patWynkid,
    required this.pickupLat,
    required this.pickupLong,
    required this.destLat,
    required this.destLong,
  //  required this.pickUp,
  //  required this.destination,
    required this.patName,
  //  required this.patPlate,
    required this.amount,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: ()async{
            showDialog(
                barrierDismissible: false,
                context: context, builder: (context){
              return Container(child:
              SpinKitCircle(
                color: kYellow,
              ),);
            });
            context.read<RideDetails>().savePickup(from!);
            context.read<RideDetails>().saveDestination(to!);
            context.read<RideDetails>().saveFair(amount!);
            context.read<RideDetails>().saveRiderName(patName!);
            context.read<RideDetails>().savePickupDate(date!);
            context.read<RideDetails>().savePatronWynkid(patWynkid!);
            context.read<RideDetails>().savePickupPos(LatLng(pickupLat!, pickupLong!));
            context.read<RideDetails>().saveDestPos(LatLng(destLat!, destLong!));
            Navigator.pop(context);

            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                RideHistoryPage()));
          },
          minLeadingWidth: 15,
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
              width: 50.w,
              child: Text(date!)),
          title: SizedBox(
            width: 150.w,
            child: Column(children: [
              Row(
                children: [
                  Image.asset('lib/assets/images/origin_donut.png',height: 19.sp,width: 19.sp,),
                  SizedBox(width: 10.w,),
                  Expanded(
                    child: Text(from!,overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600),),
                  ),
                ],
              ),
              SizedBox(height: 25.h,),
              Row(
                children: [
                  Image.asset('lib/assets/images/dest_donut.png',height: 19.sp,width: 19.sp,),
                  SizedBox(width: 10.w,),
                  Expanded(
                    child: Text(  to!,overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600),),
                  ),
                ],
              ),
            ],),
          ),
        ),
        Divider()
      ],
    );
  }
}

class WhiteWynkPass extends StatelessWidget {
  String? amount;
  String? subType;
  String? duration;
  String? passName;
  String? passId;

   WhiteWynkPass({
     Key? key,
     required this.amount,
     required this.duration,
     required this.subType,
     required this.passName,
     required this.passId,
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      width: 144.w,
     // height: 210.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5,),
          Container(
            width: 82.w,
            height: 82.w,
            child: CircleAvatar(
              backgroundColor: Color(0xff7574A0),
              child: Image.asset('lib/assets/images/wynk_pass/white_wynk.png',width: 62.w,height:24.h ,),
            ),
          ),
          Text(passName!,style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
          SizedBox(height: 3.h,),
          Text('₦$amount',style: TextStyle(fontWeight: FontWeight.w500),),
          Flexible(child: SizedBox(height: 10.h,)),
          Text('Valid for ${duration}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
          Container(
            margin: EdgeInsets.only(top: 17.h),
            height: 29.h,
            width: 114.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  backgroundColor: kBlue),
              onPressed: ()async{
                context.read<PassSubDetails>().saveSubType(subType!);
                context.read<PassSubDetails>().savePassAvatarColor(Color(0xff7574A0));
                context.read<PassSubDetails>().savePassLogo('lib/assets/images/wynk_pass/white_wynk.png');
                context.read<PassSubDetails>().savePassAmount(amount!);
                context.read<PassSubDetails>().savePassDuration(duration!);
                context.read<PassSubDetails>().savePassName(passName!);
                context.read<PassSubDetails>().subType == 'post-paid';
                context.read<PassSubDetails>().savePassId(passId!);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const PassConfirmation()));
              },
              child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
          SizedBox(height: 5.h,),
        ],
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String text;
  final Color color;
  final String time;
  const ChatTile({required this.text, Key? key, required this.color, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox
              (
              width: 36.w,height: 36.w,
              child:  CircleAvatar(
               backgroundColor: color,
              ),
            ),
            SizedBox(
              width: 11.w,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntrinsicWidth(
                    child: Container(
                      margin:EdgeInsets.only(bottom: 6.h),
                      alignment: Alignment.center,
                      padding:  EdgeInsets.only(left: 12.0.w, right: 12.0.w, top: 14.h,bottom: 14.h),
                      decoration: BoxDecoration(
                          color:Colors.black12,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(text,),
                    ),
                  ),
                  Text(time,style: TextStyle(fontSize: 11),),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
      ],
    );
  }
}


  pinDialog(BuildContext context, Widget navRoute)async{
  String? pin;
  await showDialog(
      barrierDismissible: false,
      context: context, builder: (context){
    return AlertDialog(
      contentPadding: EdgeInsets.all(30.w),
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18)
      ),
      content: Container(
        width: 301.w,
       // height:270.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter PIN',
                      style: TextStyle(fontSize: 15.sp),textAlign: TextAlign.center,),
                    SizedBox(height: 13.h,),
                    Text('Enter your 4-digit PIN to authorise \nthis transaction.',
                        style: TextStyle(fontSize: 10.sp)),
                  ],),
                GestureDetector(
                  onTap: ()=>Navigator.pop(context),
                  child: SizedBox(
                      width: 42.w,
                      height: 42.w,
                      child: Image.asset('lib/assets/images/rides/cancel1.png')),
                )
              ],),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin:  EdgeInsets.only(top: 20.h),
                height: 61.h,
                width: 260.w,
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(7),),
                child: PinCodeTextField(
                  showCursor: true,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  autoUnfocus: true,
                  autoDisposeControllers: false,
                  keyboardType: TextInputType.number,
                  onChanged: (v){},
                  autoFocus: true,
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    activeFillColor: kWhite,
                    inactiveFillColor: kWhite,
                    selectedFillColor: kWhite,
                    activeColor: kGrey1,
                    inactiveColor: kGrey1,
                    selectedColor: kGrey1,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 61.h,
                    fieldWidth: 51.w,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  controller: transactionPinController,
                  onCompleted: (value) async{
                    pin = value;
                    showDialog(
                        barrierDismissible: false,
                        context: context, builder: (context){
                      return Container(child:
                      SpinKitCircle(
                        color: kYellow,
                      ),);});
                    Map loginResponse = await sendLoginDetails(pin: pin!);
                    transactionPinController.clear();
                    if(loginResponse['statusCode'] != 200){
                      Navigator.pop(context);
                      showToast('Incorrect Transaction Pin');
                    }
                    else{
                      Navigator.pop(context);
                      Navigator.pop(context);
                      navRoute;
                    }
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  }, appContext: context,
                ),
              ),
            ),
            SizedBox(height:47.h),
          ],
        ),
      ),
    );
  });
}


class phoneField extends StatefulWidget {
  const phoneField({Key? key}) : super(key: key);

  @override
  _phoneFieldState createState() => _phoneFieldState();
}

class _phoneFieldState extends State<phoneField> {
  var bordCol = kGrey1;
  String? numCode;
  bool numComplete  = false;
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
      inputFormatters: [LengthLimitingTextInputFormatter(10),],
      autofocus: true,
      showCursor: false,
      controller: userNumLogController,
      autovalidateMode: AutovalidateMode.disabled,
      flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 5),
      dropdownIcon: Icon(Icons.arrow_drop_down,color: kYellow,),
      dropdownTextStyle: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
      decoration:  InputDecoration(
        hintText: 'Enter Phone',
        hintStyle: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,),
        focusedBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: bordCol,width: 2),
            borderRadius: BorderRadius.circular(10)
        ),
        counter: const Offstage(),
        labelText: 'Mobile Number',
        labelStyle: const TextStyle(color: Color(0xffAFAFB6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(),
        ),
      ),
      initialCountryCode: 'NG',
      showDropdownIcon: true,
      dropdownIconPosition:IconPosition.trailing,
      onChanged: (phone) {

        setState(() {
          if (userNumLogController.text.length<10){
            setState(() {
              context.read<FirstData>().saveNumComplete(false);
              bordCol = Colors.red;
            });
          }
          else{
            FocusScope.of(context).nextFocus();
            context.read<FirstData>().saveNumComplete(true);
            bordCol = kGrey1;
          }
        });
        numCode=phone.countryCode;
        context.read<FirstData>().saveNumCode(numCode!);
      },
    );
  }
}
class DataCard{
     final  String value;
     final  String duration;
     final  String serviceName;
     final  String productCode;
     final  String code;
     final  String description;
     final  String type;
     final  String amount;

      DataCard({
        required this.value,
        required this.amount,
        required this.description,
        required this.type,
        required this.code,
        required this.productCode,
        required this.serviceName,
        required this.duration
      });
     factory DataCard.fromJson(Map<String,dynamic> json){
        return DataCard(
        value : json['value'],
        duration : json['duration'],
        serviceName : json['service_name'],
        productCode : json['productCode'],
        code : json['code'],
        description : json['description'],
        type : json['type'],
        amount : json['amount']
        );
      }


}

class TvCard{
  final  String name;
  //final  String productCode;
  final  String code;
  final  String amount;

  TvCard({
    required this.name,
    required this.amount,
    required this.code,
   // required this.productCode,
  });
  factory TvCard.fromJson(Map<String,dynamic> json){
    return TvCard(
        name : json['name'],
        code : json['code'],
        amount : json['amount']
    );
  }


}

class WalletCont extends StatefulWidget {
  const WalletCont({Key? key}) : super(key: key);

  @override
  _WalletContState createState() => _WalletContState();
}

class _WalletContState extends State<WalletCont> {
  int? selectedWallet;
  bool checkingWallet = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.h,bottom: 12.h),
        height: 51.h,
        width: double.infinity,
        decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
                color: kGrey1),
            color: kWhite),
        child:Row(children: [
          SizedBox(width: 10.w,),
          Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 30.w,width: 30.w,),
          SizedBox(width: 10.w,),
          Expanded(
            child: TextField(
                controller: selectWalletCont,
                readOnly: true,
                onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                autofocus: true,
                style:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                    color: Colors.black
                ),
                decoration:   InputDecoration.collapsed(
                  hintText: 'Select Wallet',
                  hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,color: kGrey1),)),
          ),
          GestureDetector(
              onTap: ()async{

                if(context.read<WalletDetails>().wallets.isEmpty){
                  if(checkingWallet){showSnackBar(context, 'Loading wallet...');}
                  else{
                    context.read<WalletDetails>().wallets.clear();
                    checkingWallet = true;
                    showSnackBar(context, 'Please wait...');
                  final res = await walletDetails(context);
                  final wallets = res['message']as List;
                  for(var wallet in wallets){
                    if(wallet['actualBalance'] == '' ){
                      showSnackBar(context, 'We could not retrieve your wallet details at this time. Kindly bear with us.');
                    }
                    else{  Wallet wal = Wallet(walletName: wallet['walletname'],
                        walletNum: wallet['walletnumber'], currentBalance: wallet['actualBalance']);
                    context.read<WalletDetails>().saveWallet(wal);}}
                }}
                else{
                  showModalBottomSheet(
                      enableDrag: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                      ),
                      context: context,
                      builder: (context){
                        List<Wallet> wallets = context.read<WalletDetails>().wallets;
                        return Container(
                          child: ListView.builder(
                            itemCount:wallets.length ,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return RadioListTile<int>(
                                  activeColor: kYellow,
                                  secondary: Text('₦ ${wallets.elementAt(index).currentBalance!}',
                                    style: TextStyle(fontSize: 18.sp,color: kYellow,fontWeight: FontWeight.w600),),
                                  title: Text(wallets.elementAt(index).walletName!,
                                    style: TextStyle(fontSize: 20.sp,color: Colors.black),),
                                  subtitle: Text(wallets.elementAt(index).walletNum!),
                                  value: index, groupValue: selectedWallet,
                                  onChanged: (val){
                                    setState(() {
                                  selectedWallet = index;
                                  selectWalletCont.text = wallets.elementAt(index).walletName!;
                                  Navigator.pop(context);
                                  context.read<FirstData>().saveFromWallet(wallets.elementAt(index).walletNum!);
                                });
                              });
                            },
                          ),
                        );
                      });
                }
              },
              child: Icon(Icons.keyboard_arrow_down_sharp))

        ],
        )
    );
  }
}

class SmileCard{
  final  String name;
  final  String code;
  final  String price;
  final  String displayPrice;
  final  String validity;
  SmileCard({
    required this.name,
    required this.price,
    required this.code,
    required this.validity,
    required this.displayPrice
    // required this.productCode,
  });
  factory SmileCard.fromJson(Map<String,dynamic> json){
    return SmileCard(
        name : json['name'],
        code : json['code'],
        price : json['amount'],
        validity: json['price'],
        displayPrice: json['displayPrice']
    );
  }


}

class transCard{
  final  String time;
  final  String details;
  final  String amount;
  final  String productCode;
  final  String customer;
  transCard({
    required this.customer,
    required this.time,
    required this.amount,
    required this.details,
    required this.productCode,
  });
  factory transCard.fromJson(Map<String,dynamic> json){
    return transCard(
        time : json['created_date'],
        details : json['code'],
        amount : json['amount'],
      productCode: json['products'],
      customer: json['customer'],
    );
  }


}

