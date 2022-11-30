
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/constants/env.dart';
import '../../utilities/widgets.dart';
import 'package:location/location.dart';

import 'package:charts_flutter/flutter.dart' as myChart;

import '../payments/internet_sub_main.dart';
import '../payments/mobile_recharge.dart';
import '../payments/payment_list.dart';
import '../payments/qrcode.dart';
import '../payments/send_funds/sendcash.dart';
import '../setups/settings.dart';

class VaultHome extends StatefulWidget {
  const VaultHome({Key? key}) : super(key: key);

  @override
  State<VaultHome> createState() => _VaultHomeState();
}

class _VaultHomeState extends State<VaultHome>{

  SharedPreferences? prefs;
  initSharedPref()async{ prefs = await SharedPreferences.getInstance();}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    initSharedPref();
    // TODO: implement initState
    super.initState();
    seriesList = createData();
  }
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int? selectedV = 1;
  int? selectedV2 = 1;

   refresh()async{
    bool showSB = true;
    spinner(context);

    final res = await walletDetails(context);
    context.read<WalletDetails>().wallets.clear();
    final wallets = res['message'] as List;
    for(var wallet in wallets){
      if(wallet['actualBalance'] == '' && showSB == true ){
        showSB = false;
        showSnackBar(context, 'We could not retrieve your wallet details at this time. Please bear with us.');
      }
      else{
        Wallet wal = Wallet(walletName: wallet['walletname'],
          walletNum: wallet['walletnumber'], currentBalance: wallet['actualBalance']);
      context.read<WalletDetails>().saveWallet(wal);
      }}
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
      drawer:  Drawer(elevation: 0,
        backgroundColor: Colors.white,
        width: 250.w,
        child: DrawerWidget(),
      ),
      body: Padding(
        padding:  EdgeInsets.only(left: 18.w,right: 18.w,top: 59.h,bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 88.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 26.r,
                        backgroundImage: NetworkImage( 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png'),
                        child:Container(),
                      ),
                      Text(context.watch<FirstData>().userType == '2'?'Capt. ${
                          context.watch<FirstData>().user}'
                          :context.watch<FirstData>().user!,style: TextStyle(fontSize: 20.sp))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap:  () { _key.currentState!.openDrawer();},
                  child: Image.asset('lib/assets/menu.webp'),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            Expanded(
              child: ListView(
                shrinkWrap: false,
                children: [
                  Text('My Vault',style: TextStyle(fontSize: 30.sp),),
                  Container(
                      padding: EdgeInsets.only(top: 29.h,left: 14.w,right: 14.w),
                      margin: EdgeInsets.only(top: 14.h),
                      width: 365.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(5),
                          border: Border.all(color: kGrey1,)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Accounts', style: TextStyle(fontSize:22.sp ),),
                              TextButton(onPressed: ()async{
                                refresh();
                                },
                                  child: Text('Refresh',style: TextStyle(color: kBlue,fontSize: 18.sp),))
                            ],),
                          Column(children: context.watch<WalletDetails>().wallets)
                        ],)
                  ),
                  SizedBox(height: 19.h,),
                  Text('The Basics',style: TextStyle(fontSize: 17.sp),),
                  SizedBox(
                    height: 60.h,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap:()async{
                            await showDialog(
                                context: context, builder: (context){
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(10.w),
                                shape:  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)
                                ),
                                content: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Account Information',
                                            style: TextStyle(fontSize: 20.sp),textAlign: TextAlign.center,),
                                          SizedBox(height: 13.h,),
                                          Text('Fund your wallet with this account details',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(fontSize: 12.sp,color: kYellow)),
                                          SizedBox(height: 30.h,),
                                        ],),
                                      Column(children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Bank',style: TextStyle(fontSize: 15.sp),),
                                            SizedBox(width: 10.w),
                                            Flexible(
                                              child: SizedBox(child: Text('POLARIS',textAlign: TextAlign.end
                                                ,style: TextStyle(fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis),maxLines: 2,)),
                                            )
                                          ],),
                                        SizedBox(height:10.h),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Nuban',style: TextStyle(fontSize: 15.sp),),
                                            SizedBox(width: 10.w),
                                            Flexible(
                                              child: SizedBox(child: Text(context.read<FirstData>().nuban!
                                                ,style: TextStyle(fontWeight: FontWeight.w600,
                                                    overflow: TextOverflow.ellipsis),maxLines: 2,textAlign: TextAlign.end,)),
                                            )
                                          ],),
                                        SizedBox(height:10.h),
                                      ],),
                                    ],
                                  ),
                                ),
                              );
                            });
                            //spinner(context);
                           // final res =await getNubanDet();
                           // if(res['statusCode'] == 200){
                           //   Navigator.pop(context);
                           //   await showDialog(
                           //       context: context, builder: (context){
                           //     return AlertDialog(
                           //       contentPadding: EdgeInsets.all(10.w),
                           //       shape:  RoundedRectangleBorder(
                           //           borderRadius: BorderRadius.circular(18)
                           //       ),
                           //       content: Container(
                           //         child: Column(
                           //           crossAxisAlignment: CrossAxisAlignment.start,
                           //           mainAxisSize: MainAxisSize.min,
                           //           children: [
                           //             Column(
                           //               crossAxisAlignment: CrossAxisAlignment.start,
                           //               children: [
                           //                 Text('Account Information',
                           //                   style: TextStyle(fontSize: 20.sp),textAlign: TextAlign.center,),
                           //                 SizedBox(height: 13.h,),
                           //                 Text('Fund your wallet with this account details',
                           //                     overflow: TextOverflow.ellipsis,
                           //                     maxLines: 2,
                           //                     style: TextStyle(fontSize: 12.sp,color: kYellow)),
                           //                 SizedBox(height: 30.h,),
                           //               ],),
                           //             Column(children: [
                           //               Row(
                           //                 crossAxisAlignment: CrossAxisAlignment.start,
                           //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           //                 children: [
                           //                   Text('Bank',style: TextStyle(fontSize: 15.sp),),
                           //                   SizedBox(width: 10.w),
                           //                   Flexible(
                           //                     child: SizedBox(child: Text('POLARIS',textAlign: TextAlign.end
                           //                       ,style: TextStyle(fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis),maxLines: 2,)),
                           //                   )
                           //                 ],),
                           //               SizedBox(height:10.h),
                           //               Row(
                           //                 crossAxisAlignment: CrossAxisAlignment.start,
                           //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           //                 children: [
                           //                   Text('Nuban',style: TextStyle(fontSize: 15.sp),),
                           //                   SizedBox(width: 10.w),
                           //                   Flexible(
                           //                     child: SizedBox(child: Text(res['message']??'Not available yet'
                           //                       ,style: TextStyle(fontWeight: FontWeight.w600,
                           //                           overflow: TextOverflow.ellipsis),maxLines: 2,textAlign: TextAlign.end,)),
                           //                   )
                           //                 ],),
                           //               SizedBox(height:10.h),
                           //             ],),
                           //           ],
                           //         ),
                           //       ),
                           //     );
                           //   });
                           //  }
                           // else {
                           //   Navigator.pop(context);
                           //   showSnackBar(context, res['errorMessage']);
                           // }
                          //  Navigator.of(context).pushNamed('/AddFunds');
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 4.w),
                            width:81.w ,
                            height: 57.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(5),
                                border: Border.all(color: kGrey1,)
                            ),
                            child: Column(mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(child: Image.asset('lib/assets/images/functions/add_funds_ing.png',color: kBlue,)),
                                Text('Add Funds',style: TextStyle(fontSize: 10.sp,color: kBlue),)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap:(){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SendCash()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 4.w),
                            width:81.w ,
                            height: 57.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(5),
                                border: Border.all(color: kGrey1,)
                            ),
                            child: Column(mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(child: Image.asset('lib/assets/images/functions/transfer_img.png',color: kBlue,)),
                                Text('Transfers',style: TextStyle(fontSize: 10.sp,color: kBlue),)
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(right: 4.w),
                        //   width:81.w ,
                        //   height: 57.h,
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadiusDirectional.circular(5),
                        //       border: Border.all(color: kGrey1,)
                        //   ),
                        //   child: Column(mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Flexible(child: Image.asset('lib/assets/images/functions/find_atm_img.png',color: kBlue,)),
                        //       Text('Find An ATM',style: TextStyle(fontSize: 10.sp,color: kBlue),)
                        //     ],
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QRCode()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 4.w),
                            width:81.w ,
                            height: 57.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(5),
                                border: Border.all(color: kGrey1,)
                            ),
                            child: Column(mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(child: Image.asset('lib/assets/images/functions/qr_code_img.png',color: kBlue,)),
                                Text('Use Code',style: TextStyle(fontSize: 10.sp,color: kBlue),)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            showModalBottomSheet(
                              isScrollControlled: true,
                                enableDrag: false,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                                ),
                                context: context,
                                builder: (context){
                                  return Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            child: GestureDetector(
                                                onTap:(){Navigator.pop(context);},
                                                child: SizedBox(
                                                    width: 40.w,
                                                    height: 40.h,
                                                    child: Image.asset('lib/assets/images/rides/cancel1.png'))),
                                            alignment: Alignment.bottomRight,
                                          ),
                                          Text('Create new wallet',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w600),),
                                          SizedBox(height: 10.h,),
                                          Text('What would you like to name your wallet?',style: TextStyle(fontSize: 16.sp),),
                                          SizedBox(height: 35.h,),
                                          Container(
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
                                                    autofocus: true,
                                                    keyboardType: TextInputType.name,
                                                    style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                                        color: Colors.black
                                                    ),
                                                    decoration:   InputDecoration.collapsed(
                                                        hintText:  'Wallet name',
                                                        hintStyle:  TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,
                                                            color: kGrey1
                                                        )),
                                                    controller: createWalletCont,),
                                                )
                                              ],
                                              )
                                          ),
                                          SizedBox(height: 70.h,),
                                          Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap:()async{
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context, builder: (context){
                                                  return Container(child:
                                                  SpinKitCircle(
                                                    color: kYellow,
                                                  ),);});
                                                // Navigator.pop(context);
                                                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                                //     HomeMain14()), (Route<dynamic> route) => false);
                                              final res = await createWallet(createWalletCont.text);
                                              if(res['statusCode'] == 200){
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                await refresh();
                                                showToast('Wallet created successfully');
                                              }
                                              else{
                                                Navigator.pop(context);
                                                showToast('We are unable to create wallet now. Please try again');
                                              }
                                              } ,
                                              child: Container(
                                                width: 318.w,
                                                height: 50.h,
                                                margin: EdgeInsets.only(top:15.h),
                                                decoration: BoxDecoration(
                                                    color: kBlue,
                                                    borderRadius: BorderRadius.circular(7),
                                                    border: Border.all(color: Colors.black)
                                                ),
                                                child: Center(
                                                  child: Text('Create Wallet',
                                                      style: TextStyle(fontSize: 15.sp,color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                    ),
                                      ),
                                      Container(
                                        padding:EdgeInsets.all(8),
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom
                                            )),
                                      )
                                  ],);
                                });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 4.w),
                            width:81.w ,
                            height: 57.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(5),
                                border: Border.all(color: kGrey1,)
                            ),
                            child: Column(mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(child: Image.asset('lib/assets/images/functions/add_funds_ing.png',color: kBlue,)),
                                Text('Add Accounts',style: TextStyle(fontSize: 10.sp,color: kBlue),)
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 4.w),
                          width:81.w ,
                          height: 57.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(5),
                              border: Border.all(color: kGrey1,)
                          ),
                          child: Column(mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(child: Image.asset('lib/assets/images/functions/stats_img.png',color: kBlue,)),
                              Text('Stats',style: TextStyle(fontSize: 10.sp,color: kBlue),)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                Settings()));                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 4.w),
                            width:81.w ,
                            height: 57.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(5),
                                border: Border.all(color: kGrey1,)
                            ),
                            child: Column(mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(child: Image.asset('lib/assets/images/functions/settings_img.png',color: kBlue,)),
                                Text('Settings',style: TextStyle(fontSize: 10.sp,color: kBlue),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 19.h,),
                  Text('Services',style: TextStyle(fontSize: 17.sp),),
                  SizedBox(
                    height: 60.h,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                            onTap: ()async{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                  PaymentList()));
                            },
                            child: Image.asset('lib/assets/images/vault_services/Pay Bills-mdpi.png')),
                        SizedBox(width: 4.w,),
                        GestureDetector(
                            onTap: ()async{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                  MobileRecharge()));
                            },
                            child: Image.asset('lib/assets/images/vault_services/Top Up-mdpi.png')),
                        SizedBox(width: 4.w,),
                        GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                  InternetSubMain()));
                            },
                            child: Image.asset('lib/assets/images/vault_services/Subscriptions-mdpi.png')),
                        SizedBox(width: 4.w,),
                        Image.asset('lib/assets/images/vault_services/Flights-mdpi.png'),
                        SizedBox(width: 4.w,),
                        Image.asset('lib/assets/images/vault_services/WynkPoints-mdpi.png'),
                        SizedBox(width: 4.w,),
                        Image.asset('lib/assets/images/vault_services/promotions-mdpi.png'),
                        SizedBox(width: 4.w,),
                        Image.asset('lib/assets/images/vault_services/more-mdpi.png')
                      ],
                    ),
                  ),
                  SizedBox(height: 19.h,),
                  Text('Cards',style: TextStyle(fontSize: 17.sp),),
                  SizedBox(height: 9.h,),
                  Container(
                    width:365.w,
                    height: 226.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        border: Border.all(color: kGrey1,)
                    ),
                    child: Column(children: [
                      Image.asset('lib/assets/images/card.png',
                        width: 266.w,
                        height: 156,),
                      Container(
                        width: 266.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                            children: [
                            Text('Enable Virtual Card',style: TextStyle(fontSize: 12.sp),),
                            SizedBox(width: 6.w,),
                            Container(
                              width: 14.w,
                              height: 14.w,
                              child: Radio<int>(

                                value: 0,
                                activeColor: kYellow,
                                toggleable: true,
                                groupValue: selectedV,
                                onChanged: (val){
                                  print(val);
                                  setState(() {
                                    if(selectedV==0){selectedV=1;}else{selectedV=0;}
                                  });
                                },
                              ),
                            )
                          ],),
                            Row(
                              children: [
                                Text('Order Physical Card',style: TextStyle(fontSize: 12.sp),),
                                SizedBox(width: 6.w,),
                                Container(
                                  width: 14.w,
                                  height: 14.w,
                                  child: Radio<int>(
                                    value: 0,
                                    activeColor: kYellow,
                                    toggleable: true,
                                    groupValue: selectedV2,
                                    onChanged: (val){
                                      print(val);
                                      setState(() {
                                        if(selectedV2==0){selectedV2=1;}else{selectedV2=0;}
                                      });
                                    },
                                  ),
                                )
                              ],),
                        ],
                        ),
                      )
                    ],),
                  ),
                  SizedBox(height: 19.h,),
                  Text('My Cashflow',style: TextStyle(fontSize: 17.sp),),
                  SizedBox(height: 9.h,),
                  Container(
                    padding: EdgeInsets.only(left: 17.w,right: 17.w,top: 21.h,bottom: 14.h ),
                    width:365.w,
                    height: 226.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        border: Border.all(color: kGrey1,)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Review your September account activity',style: TextStyle(fontSize: 14.sp),),
                            Text('...',style: TextStyle(fontSize: 25.sp,color: Colors.black26),),
                          ],
                        ),
                        Flexible(
                          child: myChart.BarChart(
                            seriesList!,
                            animate: true,
                            vertical: true,
                            barGroupingType: myChart.BarGroupingType.grouped,
                            defaultRenderer: myChart.BarRendererConfig(
                              groupingType: myChart.BarGroupingType.grouped,
                              strokeWidthPx: 6),
                            domainAxis: myChart.OrdinalAxisSpec(
                              renderSpec: myChart.NoneRenderSpec()
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 19.h,),
                  Text('Goals',style: TextStyle(fontSize: 17.sp),),
                  SizedBox(height: 9.h,),
                  Container(
                    padding: EdgeInsets.only(left: 17.w,right: 17.w,top: 21.h,bottom: 5.h ),
                    width:365.w,
                    height: 93.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        border: Border.all(color: kGrey1,)
                    ),
                    child: Column(
                      children: [
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Create a goal',style: TextStyle(fontSize: 14.sp),),
                            Text('...',style: TextStyle(fontSize: 25.sp,color: Colors.black26),),
                          ],
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                            Image.asset('lib/assets/images/create_goal.png'),
                            SizedBox(width: 16.w,),
                            Flexible(child: Text('We can help you get started and track your progress',style: TextStyle(fontSize: 12.sp,color: Colors.black12),)),
                          ],)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 19.h,),
                  Text('Create A Budget',style: TextStyle(fontSize: 17.sp),),
                  SizedBox(height: 9.h,),
                  Container(
                    padding: EdgeInsets.only(left: 17.w,right: 17.w,top: 21.h,bottom: 14.h ),
                    width:365.w,
                    height: 226.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        border: Border.all(color: kGrey1,)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text('Manage your spending with a smart monthly budget',style: TextStyle(fontSize: 14.sp),)),
                            Text('...',style: TextStyle(fontSize: 25.sp,color: Colors.black26),),
                          ],
                        ),
                        Flexible(
                          child: myChart.BarChart(
                            seriesList!,
                            animate: true,
                            vertical: true,
                            barGroupingType: myChart.BarGroupingType.grouped,
                            defaultRenderer: myChart.BarRendererConfig(
                                groupingType: myChart.BarGroupingType.grouped,
                                strokeWidthPx: 6),
                            domainAxis: myChart.OrdinalAxisSpec(
                                renderSpec: myChart.NoneRenderSpec()
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],),
            )
        ],),
      ) ,);
  }
}

 class Sales{
  String? year;
  int? sales;
  Sales(this.year,this.sales);

}
List<myChart.Series<Sales,String>>? seriesList;
 List<myChart.Series<Sales,String>> createData(){
  final random = Random();
  final deskSalesData = [
    Sales('2015', random.nextInt(100)),
    Sales('2016', random.nextInt(100)),
    Sales('2017', random.nextInt(100)),
    Sales('2018', random.nextInt(100)),
  ];
  final anotherSalesData = [
    Sales('2015', random.nextInt(100)),
    Sales('2016', random.nextInt(100)),
    Sales('2017', random.nextInt(100)),
    Sales('2018', random.nextInt(100)),
  ];
  return [
    myChart.Series<Sales, String>(
      colorFn:  (sales,_){
        return myChart.ColorUtil.fromDartColor(kBlue);
      },
      id: 'Sales',
      domainFn: (sales,_)=>sales.year!,
      measureFn:(sales,_)=>sales.sales!,
      data: deskSalesData,
      fillColorFn: (sales,_){
        return myChart.ColorUtil.fromDartColor(kBlue);
      }
    ),
    myChart.Series<Sales, String>(
        colorFn:  (sales,_){
          return myChart.ColorUtil.fromDartColor(kYellow);
        },
        id: 'Sales',
        domainFn: (sales,_)=>sales.year!,
        measureFn:(sales,_)=>sales.sales!,
        data: anotherSalesData,
        fillColorFn: (sales,_){
          return myChart.ColorUtil.fromDartColor(kYellow);
        }
    ),
  ];
}
