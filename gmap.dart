import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';
void main(){
  runApp( ScreenUtilInit(
    designSize: const Size(390,844),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (BuildContext context, Widget? child) {
      return Test();
    },

  ));
}
class Test extends StatefulWidget {

   Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
   bool show = true;
final controller = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  Scaffold(backgroundColor: Colors.grey,
        body:  Center(child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 36.w,height: 36.w,
                  child:  CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 11.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:EdgeInsets.only(bottom: 6.h),
                        alignment: Alignment.center,
                        padding:  EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                        height: 30,
                        decoration: BoxDecoration(
                            color:Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text('vahfshfweckkfwnkfuouidjfnuyjfikfwofkpgojnirubhsekfhbbjdqjidfqpojwnofjvmoljmvikshcahi'),
                      ),
                      Text('sgfjsgdj',style: TextStyle(fontSize: 11),),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24.h,
            ),
          ],
        ),)
      ),
    );
  }
}
//Container(
//             width:MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
//             ),
//             padding: EdgeInsets.only(left: 40.w,right: 40.w,bottom: 29.h),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 15.h,),
//                 Image.asset('lib/assets/images/handle_straight.png',width: 57.w,height: 7.h,),
//                 SizedBox(height: 59.h,),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 71.w,
//                       height: 71.w,
//                       child: CircleAvatar() ,),
//                     SizedBox(width: 18.w,),
//                     Text('Cap. Adeola',style: TextStyle(fontSize: 18.sp),),
//                     Expanded(child: SizedBox(width: 103.w,)),
//                     Image.asset('lib/assets/images/rides/ios call hangup.png',width: 42.w,height: 42.w,)
//                   ],),
//               ],),),


// Container(
//                       height: 200,width: 200,
//                       color: Colors.red),
//                     Container(
//                         height: 200,width: 200,
//                         color: Colors.green)

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



//Container(
//           height: 400.h,
//           width:MediaQuery.of(context).size.width,
//           decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
//           ),
//           padding: EdgeInsets.only(left: 40.w,right: 40.w),
//           child: Column(
//             crossAxisAlignment:  CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 16.h,),
//               Visibility(
//                 visible:  show,
//                 child: Align(
//                     alignment: Alignment.center,
//                     child: Image.asset('lib/assets/images/rides/handledown.png',width: 57.w,height: 12.h,)),
//               ),
//               SizedBox(height: 28.h,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Contact Options',style: TextStyle(fontSize: 18.sp),),
//                   CircleAvatar(child: Icon(Icons.clear,color: Colors.black,),radius: 21.r,backgroundColor: Colors.grey,)
//                 ],
//               ),
//               SizedBox(height: 8.h,),
//               Text('Carrier rates will apply to all calls and messages',style: TextStyle(fontSize: 12.sp),),
//               SizedBox(height: 24.h,),
//               GestureDetector(
//                   child: ContactMedia(detail: 'Call driver in-app', image: 'lib/assets/images/rides/inapp_call.png',)),
//               SizedBox(height: 33.h,),
//               GestureDetector(
//                   child: ContactMedia(detail: 'Call driver by phone', image: 'lib/assets/images/call_by_phone.png')),
//               SizedBox(height: 33.h,),
//               ContactMedia(detail: 'Send text message to driver', image: 'lib/assets/images/message_driver.png'),
//               SizedBox(height: 33.h,),
//               ContactMedia(detail: 'Talk to support', image: 'lib/assets/images/rides/support.png'),
//               Row(children: [
//                   ElevatedButton(onPressed: (){
//         show= true;
//         setState(() {
//         });
//         }, child: Text('Show')),
//         ElevatedButton(onPressed: (){
//           show = false ;
//           setState(() {
//           });
//         }, child: Text('Show'))
//               ],)
//             ],),),