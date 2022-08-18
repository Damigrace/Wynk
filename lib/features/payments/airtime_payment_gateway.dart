import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/local_notif.dart';
import 'package:untitled/features/payments/airtime.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/features/vault/vault_home.dart';
import 'package:untitled/services.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
class PaymentGateway extends StatelessWidget {
   PaymentGateway({Key? key,required this.function,this.future,this.details}) : super(key: key);
  Function function;
  Future? future;
  String? details;
  @override
  Widget build(BuildContext context) {
    void getCapDet()async{
      final prefs = await SharedPreferences.getInstance();
      final userDet =await getCapDetails(prefs.getString('Origwynkid'));
      context.read<FirstData>().saveVaultB(userDet['actualBalance'].toString());
      context.read<FirstData>().saveTodayEarning(userDet['todayearning'].toString());
      context.read<FirstData>().saveAverageRating(userDet['averagerating'].toString());
      context.read<FirstData>().saveTodayTrip(userDet['todaytrip'].toString());
      accountBalCont.text =  '₦${context.read<FirstData>().vaultB}';

        context.read<WalletDetails>().wallets.clear();
        final res = await walletDetails(context);
        final wallets = res['message']as List;
        for(var wallet in wallets){
          Wallet wal = Wallet(walletName: wallet['walletname'],
              walletNum: wallet['walletnumber'], currentBalance: wallet['actualBalance']);
          context.read<WalletDetails>().saveWallet(wal);
        }

    }

    return Scaffold(
        body: FutureBuilder(
          future: future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print('getting data');
            if(snapshot.hasData){
              print('has data');
              print(snapshot.data);
              if(snapshot.data['statusCode'] == 200 || snapshot.data['code'] == '00'){
                getCapDet();
                return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(children: [
                          Container(
                            width: 177.w,
                            height: 177.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(9)
                            ),
                            width: 150.w,
                            height: 150.w,
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: SizedBox(
                                  width: 57.w,
                                  height: 57.w,
                                  child: Image.asset('lib/assets/images/airtime_logo/payment_success.png'))),
                        ],),
                        SizedBox(height: 27.h,),
                        Text(details??'Your payment was \nsuccessfull!',
                          style: TextStyle(fontSize: 26.sp),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 54.h,),
                        GestureDetector(
                          onTap: (){function();},
                          child: Container(

                            width: 318.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: kBlue,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text('Make another payment',
                                style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                            ),
                          ),),
                        GestureDetector(
                          onTap:(){
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                HomeMain14()), (Route<dynamic> route) => false);
                          } ,
                          child: Container(
                            width: 318.w,
                            height: 50.h,
                            margin: EdgeInsets.only(top:15.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.black)
                            ),
                            child: Center(
                              child: Text('Go Home',
                                  style: TextStyle(fontSize: 15.sp)),
                            ),
                          ),),
                      ],)
                );
              }
              else{
                print( snapshot.data['errorMessage']);
                return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Your payment was not \nsuccessfull!',
                          style: TextStyle(fontSize: 26.sp),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 54.h,),
                        GestureDetector(
                          onTap: (){function();},
                          child: Container(

                            width: 318.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: kBlue,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text('Retry payment',
                                style: TextStyle(fontSize: 15.sp,color: Colors.white),),
                            ),
                          ),),
                        GestureDetector(
                          onTap:(){
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                HomeMain14()), (Route<dynamic> route) => false);
                          } ,
                          child: Container(
                            width: 318.w,
                            height: 50.h,
                            margin: EdgeInsets.only(top:15.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.black)
                            ),
                            child: Center(
                              child: Text('Go Home',
                                  style: TextStyle(fontSize: 15.sp)),
                            ),
                          ),
                        ),
                      ],)
                );
              }
            }
            return Center(child: Container(
              width: 230,height: 100,
              child: Column(
                children: [
                  Text('Routing to Payment Gateway.\nPlease wait…',textAlign: TextAlign.center,),
                  SizedBox(height: 10.h,),
                  SpinKitCircle(color: kYellow,),
                ],
              ),),);
          },)
    );
  }
}