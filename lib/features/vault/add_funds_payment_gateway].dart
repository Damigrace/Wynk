import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/features/ride/nav_screen.dart';
import 'package:untitled/features/vault/vault_home.dart';
import 'package:untitled/main.dart';
import 'package:untitled/services.dart';

import '../../utilities/constants/colors.dart';
class VaultPaymentGateway extends StatelessWidget {
  const VaultPaymentGateway({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: determinePosition(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          Future.delayed(Duration(seconds: 2),(){
            context.read<FirstData>().goToHome == false?
            Navigator.popUntil(context, ModalRoute.withName('/NavScreen')):
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                HomeMain14()), (Route<dynamic> route) => false
            );
          });
          return Center(
            child: Container(
              child: Text('Payment Success!',style: TextStyle(fontSize: 30.sp),),
            ),
          );
        }
        return Center(child: Container(
          width: 230,height: 100,
          child: Column(
            children: [
              Text('Routing to Payment Gateway.\nPlease wait…',textAlign: TextAlign.center,),
              SizedBox(height: 10.h,),
              SpinKitWave(color: kYellow,),
            ],
          ),),);
      },)
    );
  }
}