// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';
// import 'package:wynk/controllers.dart';
// import 'package:wynk/features/payments/payment_list.dart';
// import 'package:wynk/main.dart';
//
// import '../../utilities/constants/colors.dart';
// import '../../utilities/constants/textstyles.dart';
// import '../../utilities/widgets.dart';
// import 'payment_gateway.dart';
// class LasuSchFees extends StatefulWidget {
//   const LasuSchFees({Key? key}) : super(key: key);
//
//   @override
//   _LasuSchFeesState createState() => _LasuSchFeesState();
// }
//
// class _LasuSchFeesState extends State<LasuSchFees> {
//   String? pin;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.only(left: 36.w,right:36.w,top: 77.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 backButton(context),
//                 SizedBox(height: 31.h,),
//                 Text('Lagos State\nUniversity',style: TextStyle(fontSize: 26.sp),),
//                 SizedBox(height: 37.h,),
//                 Text('Select Package',style: TextStyle(fontSize: 12.5.sp),),
//                 Container(
//                     margin: EdgeInsets.only(top: 14.h,bottom: 27.h),
//                     height: 61.h,
//                     width: double.infinity,
//                     decoration:  BoxDecoration(
//                         borderRadius: BorderRadius.circular(7),
//                         border: Border.all(
//                             color: kGrey1),
//                         color: kWhite),
//                     child:Row(children: [
//                       SizedBox(width: 18.w,),
//                       Expanded(
//                         child: TextField(
//                             readOnly: true,
//                             onEditingComplete:()=> FocusScope.of(context).nextFocus(),
//                             autofocus: true,
//                             style: TextStyle(fontSize: 15.sp),
//                             decoration:   InputDecoration.collapsed(
//                                 hintText: 'Land Use Charge Default',
//                                 hintStyle:  TextStyle(fontSize: 15.sp,
//                                     color: kBlack1
//                                 ))),
//                       ),
//                       Icon(
//                           Icons.keyboard_arrow_down_sharp
//                       )
//                     ],
//                     )
//                 ),
//                 Text('Bill Number / Customer Reference',style: TextStyle(fontSize: 12.5.sp),),
//                 Container(
//                     margin: EdgeInsets.only(bottom: 27.h,top: 14.h),
//                     padding: EdgeInsets.symmetric(horizontal: 12.w),
//                     height: 61.h,
//                     width: 318.w,
//                     decoration:  BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         border: Border.all(
//                             color: kGrey1),
//                         color: kWhite),
//                     child:Align(
//                       alignment: Alignment.center,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               maxLines:1 ,
//                               cursorHeight: 0,
//                               cursorWidth: 0,
//                               onEditingComplete:()=> FocusScope.of(context).nextFocus(),
//                               autofocus: true,
//                               keyboardType:TextInputType.text,
//                               style: TextStyle(fontSize: 15.sp,),
//                               decoration:   InputDecoration.collapsed(
//                                   hintText:  'Enter 10 digit bill number',
//                                   hintStyle:  TextStyle(fontSize: 15.sp,
//                                       color: kBlack1
//                                   )),),
//                           ),
//                         ],
//                       ),
//                     )
//                 ),
//                 Text('Amount',style: TextStyle(fontSize: 12.5.sp),),
//                 Container(
//                     margin: EdgeInsets.only(bottom: 27.h,top: 14.h),
//                     padding: EdgeInsets.symmetric(horizontal: 12.w),
//                     height: 61.h,
//                     width: 318.w,
//                     decoration:  BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         border: Border.all(
//                             color: kGrey1),
//                         color: kWhite),
//                     child:Align(
//                       alignment: Alignment.center,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               maxLines:1 ,
//                               cursorHeight: 0,
//                               cursorWidth: 0,
//                               onEditingComplete:()=> FocusScope.of(context).nextFocus(),
//                               autofocus: true,
//                               keyboardType:TextInputType.text,
//                               style: TextStyle(fontSize: 15.sp,),
//                               decoration:   InputDecoration.collapsed(
//                                   hintText:  'Minimum of ₦‎ 2,000 ',
//                                   hintStyle:  TextStyle(fontSize: 15.sp,
//                                       color: kBlack1
//                                   )),),
//                           ),
//                         ],
//                       ),
//                     )
//                 ),
//                 Text('You will be charged a fee of ₦‎ 120 for \nthis transaction.',style: TextStyle(fontSize: 12.5.sp,color: Colors.red),),
//                 SizedBox(height: 88.h,),
//                 SizedBox(
//                   height: 50.h,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         primary: kBlue),
//                     onPressed: () async {
//                       await showDialog(
//                           barrierDismissible: false,
//                           context: context, builder: (context){
//                         return AlertDialog(
//                           contentPadding: EdgeInsets.all(30.w),
//                           shape:  RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18)
//                           ),
//                           content: Container(
//                             width: 301.w,
//                             height:270.h,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text('Enter PIN',
//                                           style: TextStyle(fontSize: 15.sp),textAlign: TextAlign.center,),
//                                         SizedBox(height: 13.h,),
//                                         Text('Enter your 4-digit PIN to authorise \nthis transaction.',
//                                             style: TextStyle(fontSize: 10.sp)),
//                                       ],),
//                                     GestureDetector(
//                                       onTap: ()=>Navigator.pop(context),
//                                       child: SizedBox(
//                                           width: 42.w,
//                                           height: 42.w,
//                                           child: Image.asset('lib/assets/images/rides/cancel1.png')),
//                                     )
//                                   ],),
//
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Container(
//                                     margin:  EdgeInsets.only(top: 20.h,bottom: 28.h),
//                                     height: 61.h,
//                                     width: 260.w,
//                                     decoration:  BoxDecoration(
//                                       borderRadius: BorderRadius.circular(7),),
//                                     child: PinCodeTextField(
//                                       showCursor: true,
//                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                       autoUnfocus: true,
//                                       autoDisposeControllers: false,
//                                       keyboardType: TextInputType.number,
//                                       onChanged: (v){},
//                                       autoFocus: true,
//                                       length: 4,
//                                       obscureText: true,
//                                       animationType: AnimationType.fade,
//                                       pinTheme: PinTheme(
//                                         activeFillColor: kWhite,
//                                         inactiveFillColor: kWhite,
//                                         selectedFillColor: kWhite,
//                                         activeColor: kGrey1,
//                                         inactiveColor: kGrey1,
//                                         selectedColor: kGrey1,
//                                         shape: PinCodeFieldShape.box,
//                                         borderRadius: BorderRadius.circular(5),
//                                         fieldHeight: 61.h,
//                                         fieldWidth: 51.w,
//                                       ),
//                                       animationDuration: Duration(milliseconds: 300),
//                                       controller: transactionPinController,
//                                       onCompleted: (v) async{
//                                         pin=v;
//                                         Navigator.pop(context);
//
//                                       },
//                                       beforeTextPaste: (text) {
//                                         print("Allowing to paste $text");
//                                         //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                                         //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                                         return true;
//                                       }, appContext: context,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height:47.h),
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Container(
//                                     height: 50.h,
//                                     width: 241.w,
//                                     child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           backgroundColor: kBlue),
//                                       onPressed: ()  {
//                                         Navigator.pop(context);
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     PaymentGateway(
//                                                       function: (){
//                                                         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
//                                                             PaymentList()));
//                                                       },
//                                                     )));
//                                       },
//                                       child: Text('Confirm',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       });
//                     },
//                     child: Text('Pay',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],),
//     ));
//   }
// }
