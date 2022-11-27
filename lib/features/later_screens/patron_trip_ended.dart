import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';


import '../../controllers.dart';
import '../../main.dart';
import '../../services.dart';
import '../../utilities/constants/colors.dart';
import '../../utilities/widgets.dart';
import '../ride/patron_invoice.dart';
class PatronTripEnded extends StatefulWidget {
  const PatronTripEnded({Key? key}) : super(key: key);

  @override
  _PatronTripEndedState createState() => _PatronTripEndedState();
}

class _PatronTripEndedState extends State<PatronTripEnded> {
  double? rate = 0;
  @override
  Widget build(BuildContext context) {
    print(context.read<CaptainDetails>().total!);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 67.h,),
            Row(
            children: [
              SizedBox(width: 111.w,),
              Text('Trip Ended',style: TextStyle(fontSize: 26.sp),),
              Flexible(
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
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
                Text('NGN ${context.read<CaptainDetails>().total!}',style: TextStyle(fontSize: 18.sp),)
              ],),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40.h),
              width: 110.w,height: 110.w,child: CircleAvatar(
              backgroundImage: NetworkImage('https://wynk.ng/stagging-api/picture/${context.read<CaptainDetails>().capId}.png'),
            ),),
            const Text('Please rate your Captain'),
            SizedBox(height: 22.h,),
            RatingBar.builder(itemBuilder: (context,_){return
                const Icon(Icons.star,color: kYellow,);}, onRatingUpdate: (double value) {
              print(value);
              rate = value;
              },),
            Container(
                margin: EdgeInsets.only(top: 16.h,bottom: 47.h),
                width: 309.w,
               // height: 198.h,
                child: TextField(
                  controller: riderCommentCont,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
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
            Container(
                height: 51.h,
                width: MediaQuery.of(context).size.width-42.w,
                child: ElevatedButton(onPressed: ()async{
                  spinner(context);
                  rideRating(rideCode: context.read<CaptainDetails>().rideCode!, star: rate!,
                      comment: riderCommentCont.text, wynikd:context.read<FirstData>().uniqueId! );
                 refresh(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                      PatronInvoice()));
                },
                  child: Text('Submit'),style: ElevatedButton.styleFrom(backgroundColor: kBlue),)),

        ],),
      ),
    );
  }
}
