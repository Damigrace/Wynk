import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:untitled/main.dart';
import 'package:untitled/services.dart';
import 'package:untitled/utilities/constants/colors.dart';

import '../../controllers.dart';
import '../../utilities/widgets.dart';
class DriverFound extends StatefulWidget {
  DriverFound({Key? key}) : super(key: key);

  @override
  State<DriverFound> createState() => _DriverFoundState();
}

class _DriverFoundState extends State<DriverFound> {
  String? rating = '4.4';

  String? carMake = 'Toyota';

  String? carModel = 'Camry';

  String? carColor = 'Blue';

  String? captainName = 'Adeola';

  String? captainId = 'WYNK1234567';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 323.h,
      width:MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      padding: EdgeInsets.only(left: 40.w,right: 40.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:  CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10.h,),
          Image.asset('lib/assets/images/handle.png',width: 57.w,height: 12.h,),
          SizedBox(height: 22.h,),
          Text('Captain arrives in some minutes',style: TextStyle(fontSize: 18.sp),),
          SizedBox(height: 48.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$carColor $carMake $carModel',style: TextStyle(fontSize: 10.sp),),
                  SizedBox(height: 9.h,),
                  Text(captainId!,style: TextStyle(fontSize: 18.sp),),
                  SizedBox(height: 22.h,),
                  Text('Your Captain is $captainName',style: TextStyle(fontSize: 18.sp),),
                ],),
              Container(
                width: 71.w,height: 81.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(child: CircleAvatar(
                      radius: 35.w,
                    )),
                    Positioned(

                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal:9.w,vertical: 6.h ),
                          height: 21.h,
                          width:49.w,
                          decoration:  BoxDecoration(
                              color: kBlue,
                              borderRadius:BorderRadius.circular(25)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('lib/assets/images/star.png'),
                              Text(rating??'unknown',style: TextStyle(fontSize: 10.sp,color: Colors.white),)
                            ],),
                        ))
                  ],
                ),
              )
            ],),
          Container(
            margin: EdgeInsets.only(top: 53.h),
            height: 51.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: kBlue
              ),
              onPressed: (){
                context.read<FirstData>().topBar(false);
                context.read<FirstData>().backButton(true);
                ContactCaptain(context);
                controller1.jumpTo(0.2);

              },
              child: Text('Contact Captain',style: TextStyle(fontSize: 15.sp),),
            ),
          ),
        ],),);
  }
}  final controller = DraggableScrollableController();
Future CallCaptainInApp(BuildContext context){

 return showModalBottomSheet(
   isDismissible: false,
     enableDrag: false,
     isScrollControlled: true,
     backgroundColor: Colors.transparent,
     barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      context: context, builder: (context){
    return DraggableScrollableSheet(
        controller: controller2,
        maxChildSize: 0.5,
        initialChildSize: 0.5,
        minChildSize: 0.05,
        builder: (context, scrollController1) {
          return Container(
            width:MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
            ),
            padding: EdgeInsets.only(left: 40.w,right: 40.w,),
            child: SingleChildScrollView(
                controller: scrollController1,
                physics: ClampingScrollPhysics(),
                child: LayoutBuilder(builder: (context, constraints) {
                  if(controller2.size < 0.2){

                    controller2.jumpTo(0.2);
                    controller1.jumpTo(0.1);

                    return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h,),
                      Image.asset('lib/assets/images/handle_straight.png',width: 57.w,height: 7.h,),
                      SizedBox(height: 59.h,),
                      Row(
                        children: [
                          SizedBox(
                            width: 71.w,
                            height: 71.w,
                            child: Hero(
                                tag: 'CA',
                                child: CircleAvatar()) ,),
                          SizedBox(width: 18.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cap. Adeola',style: TextStyle(fontSize: 18.sp),),
                              SizedBox(height: 4.h,),
                              Text('Ringing...',style: TextStyle(fontSize: 12.sp,color: Colors.grey),),
                            ],
                          ),
                          Expanded(child: SizedBox(width: 103.w,)),
                          GestureDetector(
                              onTap: (){
                                Navigator.pop(context);controller1.jumpTo(0.4);
                                context.read<FirstData>().backButton(true);},

                              child: Image.asset('lib/assets/images/rides/ios call hangup.png',width: 42.w,height: 42.w,))
                        ],),
                    ],);}
                  else{print('2');return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15.h,),
                      Image.asset('lib/assets/images/handle_straight.png',width: 57.w,height: 7.h,),
                      Container(
                        margin: EdgeInsets.only(top: 59.h,bottom: 8.h) ,
                        width: 71.w,
                        height: 71.w,
                        child: Hero(
                            tag: 'CA',
                            child: CircleAvatar()) ,),
                      Text('Cap. Adeola',style: TextStyle(fontSize: 18.sp),),
                      SizedBox(height: 8.h,),
                      Text('Ringing...',style: TextStyle(fontSize: 12.sp,color: Colors.grey),),
                      SizedBox(height: 81.h,),
                      SizedBox(
                          height: 50.w,
                          width: 50.w,
                          child: GestureDetector(
                              onTap: (){Navigator.pop(context);controller1.jumpTo(0.4);
                              context.read<FirstData>().backButton(true);},
                              child: Image.asset('lib/assets/images/rides/ios call hangup.png'))),
                    ],);}
                })
            ),);
        });
  });
}
String oneText = '';
Future ContactCaptain(BuildContext context){
  return showModalBottomSheet(
    barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      context: context, builder: (context){
    return Container(
      height: 370.h,
      width:MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      padding: EdgeInsets.only(left: 40.w,right: 40.w),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h,),
          Align(
              alignment: Alignment.center,
              child: Image.asset('lib/assets/images/rides/handledown.png',width: 57.w,height: 12.h,)),
          SizedBox(height: 28.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Contact Options',style: TextStyle(fontSize: 18.sp),),
              CircleAvatar(child: Icon(Icons.clear,color: Colors.black,),radius: 21.r,backgroundColor: Colors.grey,)
            ],
          ),
          SizedBox(height: 8.h,),
          Text('Carrier rates will apply to all calls and messages',style: TextStyle(fontSize: 12.sp),),
          SizedBox(height: 24.h,),
          GestureDetector(
              onTap: (){
                Navigator.pop(context);
                context.read<FirstData>().backButton(false);
                CallCaptainInApp(context);
             },
              child: ContactMedia(detail: 'Call driver in-app', image: 'lib/assets/images/rides/callD_inapp.png',)),
          SizedBox(height: 33.h,),
          GestureDetector(
              child: ContactMedia(detail: 'Call driver by phone', image: 'lib/assets/images/rides/callD_byp.png')),
          SizedBox(height: 33.h,),
          GestureDetector(
              onTap: (){
                Navigator.pop(context);
                RiderMessage(context);
              },
              child: ContactMedia(detail: 'Send text message to driver', image: 'lib/assets/images/rides/message.png')),
          SizedBox(height: 33.h,),
          ContactMedia(detail: 'Talk to support', image: 'lib/assets/images/rides/supp.png')
        ],),);
  });
}
Future RiderMessage(BuildContext context){
  return showModalBottomSheet(
      barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      context: context, builder: (context){
    return Container(
      height: 456.h,
      width:MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      padding: EdgeInsets.only(left: 35.w,right: 35.w),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14.h,),
          Align(
              alignment: Alignment.center,
              child: Image.asset('lib/assets/images/handle_straight.png',width: 57.w,height: 12.h,)),
          SizedBox(height: 12.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width:71.w,height: 71.w,child: CircleAvatar()),
              SizedBox(width: 3.w),
              Text('Message Capt.Adeola',style: TextStyle(fontSize: 18.sp),),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 16.h,bottom: 47.h),
            width: 322.w,
            height: 207.h,
            child: TextField(
              controller: riderMessageFieldCont,
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
          SizedBox(
            height: 51.h,
            width: double.infinity,
            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                  primary: kBlue),
              onPressed: ()async{
                Navigator.pop(context);
                ChatScreen(context);
              },
              child: Text('Send Message',style: TextStyle(fontSize: 15.sp),),
            ),
          ),],),);
  });
}
Future ChatS(BuildContext context){
  return showModalBottomSheet(
      barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      context: context, builder: (context){
    return Container(
      height: 456.h,
      width:MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      padding: EdgeInsets.only(left: 35.w,right: 35.w,bottom:MediaQuery.of(context).viewInsets.bottom ),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14.h,),
          Align(
              alignment: Alignment.center,
              child: Image.asset('lib/assets/images/handle_straight.png',width: 57.w,height: 12.h,)),
          SizedBox(height: 12.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width:71.w,height: 71.w,child: CircleAvatar()),
              SizedBox(width: 3.w),
              Text('Message Capt.Adeola',style: TextStyle(fontSize: 18.sp),),
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 16.h,bottom: 47.h),
              width: 322.w,
              height: 207.h,
              child: TextField(
                controller: riderMessageFieldCont,
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
          SizedBox(
            height: 51.h,
            width: double.infinity,
            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                  primary: kBlue),
              onPressed: ()async{
                ChatScreen(context);
                riderMessageFieldCont.clear();

              },
              child: Text('Send Message',style: TextStyle(fontSize: 15.sp),),
            ),
          ),],),);

  });
}

Future ChatScreen(BuildContext context){
  return showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
      ),
      context: context, builder: (context){
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
          controller: controller4,
          maxChildSize: 0.9,
          initialChildSize: 0.8,
          minChildSize: 0.2,
          builder: (context, scrollController3) {
            return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                padding: EdgeInsets.only(left: 40.w,right: 40.w,top: 14.h),
                height: 766.h,
                width:MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset('lib/assets/images/handle_straight.png',width: 57.w,height: 7.h,)),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin:  EdgeInsets.only(top: 4.h),
                        width: 43.w,
                        height: 43.w,
                        child: Image.asset('lib/assets/images/rides/cancel1.png'),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child:   SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        reverse: true,
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children:
                          context.watch<FirstData>().messages
                        ),
                      ),),
                    SizedBox(height: 3.h,),
                    Expanded(
                        flex: 1,
                        child:Row(children: [
                          InputBox(
                              maxLine: null,
                              hintText: 'Type your message here', controller: riderMessageFieldCont,
                              textInputType: TextInputType.multiline),
                          SizedBox(width: 9.w,),
                          GestureDetector(child: Image.asset('lib/assets/images/riderSend.png',width: 51.w,height: 51.w,),onTap: (){
                              context.read<FirstData>().addChat(ChatTile(
                                  text: riderMessageFieldCont.text,
                                  color: Colors.blue, time: 'Just now'));
                            riderMessageFieldCont.clear();
                          },)
                        ],)),
                    SizedBox(height: 10.h,)
                  ],
                ),
              );
            },);
          }),
    );
  });
}
class ContactMedia extends StatelessWidget {
  String? detail;
  String? image;
  ContactMedia({required this.detail,required this.image});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 2,
          child: Container(
              alignment: Alignment.topLeft,
              child: Image.asset(image!,height: 21.w,width: 21.w,)),),
        Expanded(
          flex: 11,
          child:Text(detail!,style: TextStyle(fontSize: 18.sp),),
        )
      ],);
  }
}