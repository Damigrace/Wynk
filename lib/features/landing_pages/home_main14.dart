import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/landing_pages/welcome_page.dart';
import 'package:untitled/features/login_feature/login_page.dart';
import 'package:untitled/features/ride/ride_home.dart';
import 'package:untitled/features/registration_feature/image.dart';
import 'package:untitled/features/registration_feature/patron_captain_signup.dart';
import 'package:untitled/features/registration_feature/signup_camera_permission.dart';
import 'package:untitled/main.dart';
import '../../controllers.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/textstyles.dart';
import 'package:intl/intl.dart';



class HomeMain14 extends StatefulWidget {
  const HomeMain14({Key? key}) : super(key: key);

  @override
  State<HomeMain14> createState() => _HomeMain14State();
}

class _HomeMain14State extends State<HomeMain14> {
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  File? snappedP;
  @override
  void initState() {
    accountBalCont.text =  '₦${balanceFormatter.format(vaultBalance)}';
    snappedP=context.read<FirstData>().providerImage;
    // TODO: implement initState
    super.initState();
  }
  File? imageFile;
  num vaultBalance=0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool showSpinner=false;
  List<String> drawerItems=[
    'Home',
    'Rides',
    'Payments',
    'My Vault',
    'Inbox',
    'Settings',
    'Support',
    'Terms & Conditions',
    'Log Out'
  ];
  String? text;
  String? drawerN;
TextEditingController accountBalCont = TextEditingController();
  wynkDrawer(){
    return  ListView(children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text(drawerN??'User',style: TextStyle(fontSize: 22),),
        currentAccountPicture: CircleAvatar(radius: 28.r,
          child: ClipRect(child: Image.asset('lib/assets/images/wynkimage.png',scale: 4,)),), accountEmail: null,),
      Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
        color: Colors.white54,
        height:400.h,
        child: ListView.builder(
          itemCount: drawerItems.length,
          itemBuilder: (context,index)=>Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(drawerItems[index],style: TextStyle(fontSize: 18.sp),),
              SizedBox(height: 20.h,)

            ],),),
      )
    ],);
  }
  bool showBalance = true;
  Icon icon = Icon(CupertinoIcons.eye_slash_fill);
  @override
  Widget build(BuildContext context) {
    text=context.read<FirstData>().username?.toLowerCase();
    drawerN=text?.replaceFirst(text![0], text![0].toUpperCase());
    print('homepage called');
    return WillPopScope(
      onWillPop: ()async{
        await showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text('Please Confirm',style: TextStyle(fontSize: 17.sp),),
          content: const Text('Do you want to log out?'),
          actions: [
            TextButton(onPressed: ()async{Navigator.pop(context);}, child: Text('No')),
            TextButton(onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const LoginPage()
              ));
            }, child: Text('Yes',textAlign: TextAlign.end,))
          ],
        );
      });return false;},

      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(backgroundColor: Colors.white,
          key: _key,
          drawer:  Drawer(
            width: 250.w,
            child: wynkDrawer(),
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leadingWidth: 70.w,
            leading:Padding(
              padding:  EdgeInsets.only(top: 8.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>  UserSelector()));
                },
                child: snappedP==null?CircleAvatar(
                  child: Text(text!.toUpperCase().substring(0,2),style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
                ):CircleAvatar(backgroundImage: FileImage(snappedP!),)
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
          body: SafeArea(
            child:Padding(
                padding:  EdgeInsets.only(left: 15.w,right: 15.w),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(children: [
                        Positioned(top: 12.h,child:
                        Text(drawerN!,style: TextStyle(fontSize: 20.sp,),)),
                        Positioned(top: 13.h,right: 13.w,
                            child: Container(width: 147.w,height:25.h,
                              child: TextField(
                            textAlign: TextAlign.end,
                            style:TextStyle(color: Colors.green,fontSize: 18.sp) ,
                            obscureText: showBalance,
                            obscuringCharacter: '*',
                            decoration: InputDecoration.collapsed(hintText: ''),
                            readOnly: true,
                            controller: accountBalCont,
                            ),
                        )),
                        Positioned(top: 12.h,right: 13.w, child:  Row(
                          children: [
                            IconButton(icon: icon,onPressed: (){
                              setState(() {
                               showBalance = !showBalance;
                               showBalance == true?icon=Icon(CupertinoIcons.eye_slash_fill):icon=Icon(CupertinoIcons.eye_fill);
                              });
                            }),
                            Text( 'Vault Balance',style:TextStyle(color: Colors.black87,fontSize: 18.sp))
                          ],
                        ))
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
                                    try  {
                                        setState(() {
                                          showSpinner = true;
                                        });

                                        Position currentLocation =
                                            await determinePosition(context);
                                        context
                                            .read<FirstData>()
                                            .saveCurrentLocat(
                                                currentLocation.latitude,
                                                currentLocation.longitude);
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RideHome()));
                                      }
                                      catch(e){print(e);}
                                    },),
                                    SizedBox(width: 7.w,),
                                    Image.asset('lib/assets/images/functions/top_up.png',),
                                    SizedBox(width: 7.w,),
                                    Image.asset('lib/assets/images/functions/subscriptions.png',height: 200,),
                                    SizedBox(width: 7.w,),
                                    Image.asset('lib/assets/images/functions/delivery.png'),
                                    SizedBox(width: 7.w,),
                                    Image.asset('lib/assets/images/functions/foodie.png'),
                                    SizedBox(width: 7.w,),
                                    Image.asset('lib/assets/images/functions/send_funds-removebg-preview (1).png'),
                                    SizedBox(width: 7.w,),
                                    Image.asset('lib/assets/images/functions/request_funds-removebg-preview (1).png'),
                                    SizedBox(width: 7.w,),
                                    Image.asset('lib/assets/images/functions/my vault.png')
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
                                  Image.asset('lib/assets/images/quick_pay/image-6-1@1x.png'),
                                    SizedBox(width: 7.w,),
                                  Image.asset('lib/assets/images/quick_pay/image-7-1@1x.png'),
                                    SizedBox(width: 7.w,),
                                  Image.asset('lib/assets/images/quick_pay/image-8-1@1x.png'),
                                    SizedBox(width: 7.w,),
                                  Image.asset('lib/assets/images/quick_pay/image-9-1@1x.png'),
                                    SizedBox(width: 7.w,),
                                  Image.asset('lib/assets/images/quick_pay/image-10-1@1x.png'),
                                    SizedBox(width: 7.w,),
                                  Image.asset('lib/assets/images/quick_pay/image-11-1@1x.png'),
                                    SizedBox(width: 7.w,),
                                  Image.asset('lib/assets/images/quick_pay/image-12-1@1x.png'),
                                    SizedBox(width: 7.w,),
                                  Image.asset('lib/assets/images/quick_pay/image-13-1@1x.png'),
                                  ],
                                )),
                            Padding(
                              padding:  EdgeInsets.only(left: 8.w,top: 17.h,bottom: 11.h),
                              child: Text('Discover Wynk',style: kTextStyle5,),
                            ),
                            SizedBox(
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
                            Padding(
                              padding:  EdgeInsets.only(left: 8.w,top: 17.h,bottom: 11.h),
                              child: Text('Discounts and Promotions',style: kTextStyle5,),
                            ),
                            SizedBox(
                                height: 150.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Discounts(image: Image.asset('lib/assets/images/discounts/item1.png'), itemDescription: 'Vegan Salad with Kebab and sauce',),
                                    Discounts(image: Image.asset('lib/assets/images/discounts/item2.png'), itemDescription: 'Chocolate bar with Cream',),
                                    Discounts(image: Image.asset('lib/assets/images/discounts/item3.png'), itemDescription: 'Special Salmon Fish Sauce',),
                                  ],
                                )),
                            SizedBox(height:10.h ,)
                          ],),
                      ))
              ],)
            ) ,
          ),
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
          border:Border.all(color: kGrey1,width: 0.5),
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
                padding:EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                child:Text(itemDescription) ,),))
        ],));
  }
}