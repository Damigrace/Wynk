import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wynk/features/ride/patron_invoice.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
class TripEnded extends StatefulWidget {
  const TripEnded({Key? key}) : super(key: key);

  @override
  _TripEndedState createState() => _TripEndedState();
}

class _TripEndedState extends State<TripEnded> {
  double rate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 67.h,),
          Row(
          children: [
            SizedBox(width: 111.w,),
            Text('Trip Endedd',style: TextStyle(fontSize: 26.sp),),
            Flexible(
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin:  EdgeInsets.only(top: 4.h,left: 66.w,right: 25.w),
                  width: 42.w,
                  height: 42.w,
                  child: Image.asset('lib/assets/images/rides/cancel1.png'),
                ),
              ),
            ),
        ],),
          Container(
            margin: EdgeInsets.only(top: 29.h,bottom: 64.h),
            padding: EdgeInsets.symmetric(vertical: 21.h,horizontal: 25.w),
            decoration:  BoxDecoration(
              border: Border.all(color: Colors.black12)
            ),
            child: Row(children: [
              Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
              SizedBox(width: 18.w,),
              Text('Wynk Vault',style: TextStyle(fontSize: 18.sp),),
              Flexible(child: SizedBox(width: 1000,)),
              Text('₦‎ ---',style: TextStyle(fontSize: 18.sp),)
            ],),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 40.h),
            width: 110.w,height: 110.w,child: CircleAvatar(),),
          const Text('Please rate your captain'),
          SizedBox(height: 22.h,),
          RatingBar.builder(itemBuilder: (context,_){return
              const Icon(Icons.star,color: kYellow,);}, onRatingUpdate: (double value) { print(value); },),
          Container(
              margin: EdgeInsets.only(top: 16.h,bottom: 47.h),
              width: 309.w,
              height: 198.h,
              child: TextField(
                controller: riderCommentCont,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                    hintText: "Enter message here",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.redAccent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: kBlue)
                    )
                ),
              )
          ),
          Flexible(child: SizedBox(height: 22.h,)),
          Container(
              height: 51.h,
              width: MediaQuery.of(context).size.width-42.w,
              child: ElevatedButton(onPressed: () async {
                spinner(context);
                rideRating(rideCode: context.read<CaptainDetails>().rideCode!, star: rate,
                    comment: riderCommentCont.text, wynikd:context.read<FirstData>().uniqueId! );
                final userDet =await getCapDetails(context.read<FirstData>().uniqueId);
                context.read<FirstData>().saveVaultB(userDet['actualBalance'].toString());
                context.read<FirstData>().saveTodayEarning(userDet['todayearning'].toString());
                context.read<FirstData>().saveAverageRating(userDet['averagerating'].toString());
                context.read<FirstData>().saveTodayTrip(userDet['todaytrip'].toString());
                accountBalCont.text =  '₦${userDet['actualBalance'].toString()}';
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                    PatronInvoice()));
              }, child: Text('Submit'),style: ElevatedButton.styleFrom(backgroundColor: kBlue),)),
          Flexible(child: SizedBox(height: 10.h,)),
      ],),
    );
  }
}
