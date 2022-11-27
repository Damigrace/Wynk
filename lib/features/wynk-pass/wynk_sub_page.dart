import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers.dart';
import '../../main.dart';
import '../../utilities/widgets.dart';
class WynkPassHome extends StatefulWidget {
  const WynkPassHome({Key? key}) : super(key: key);

  @override
  _WynkPassHomeState createState() => _WynkPassHomeState();
}

class _WynkPassHomeState extends State<WynkPassHome> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final balanceFormatter = NumberFormat("#,##0.00", "en_NG");
  num vaultBalance=0;
  bool showBalance = true;
  Icon icon = Icon(CupertinoIcons.eye_slash_fill);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer:  Drawer(elevation: 0,
        backgroundColor: Colors.white,
        width: 250.w,
        child: DrawerWidget(),
      ),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(left: 15.w,top: 10.h,right: 7.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                padding: EdgeInsets.only(right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                    width: 91.w,
                    height: 88.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 26.r,
                          backgroundImage: NetworkImage( 'http://wynk.ng/stagging-api/picture/${context.read<FirstData>().uniqueId}.png'),
                          child:Container(),
                        ),
                        Text('Captain',style: TextStyle(fontSize: 20.sp))
                      ],
                    ),
                  ),
                    GestureDetector(
                      onTap:  () { _key.currentState!.openDrawer();},
                      child: Image.asset('lib/assets/menu.webp'),
                    )
                ],),
              ),
              Container(
                padding: EdgeInsets.only(left: 14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wynk Pass',style: TextStyle(fontSize: 30.sp),),
                    Text('Select The Plan That Suits Your Needs',style: TextStyle(fontSize: 18.sp,color: Colors.black26)),
                    SizedBox(height: 36.h,),
                    Container(
                      padding:  EdgeInsets.only(top: 15.h,right: 7.w),
                      alignment: Alignment.bottomLeft,
                      child: Text('Pre-paid Plans',style: TextStyle(color: Colors.black,
                          fontSize: 22.sp, fontWeight: FontWeight.w500),),),
                    SizedBox(height: 10.h,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: context.read<PassSubDetails>().prepaidPasses)
                      ,),
                    Container(
                      padding:  EdgeInsets.only(top: 15.h,right: 7.w,bottom: 10),
                      alignment: Alignment.bottomLeft,
                      child: Text('Post-paid Plans',style: TextStyle(color: Colors.black,
                          fontSize: 22.sp, fontWeight: FontWeight.w500),),),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: context.read<PassSubDetails>().postpaidPasses)
                      ,),
                    SizedBox(height: 10.h,),
                ],),
              )
            ],),
          ),
        ),
      ),
    );
  }


}
// Container WhiteWynkPass(BuildContext context , String price, String subType) {
//
//   return Container(
//     child: Container(
//       width: 144.w,
//       height: 210.h,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.black)
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 82.w,
//             height: 82.w,
//             child: CircleAvatar(
//               backgroundColor: Color(0xff7574A0),
//               child: Image.asset('lib/assets/images/wynk_pass/white_wynk.png',width: 62.w,height:24.h ,),
//             ),
//           ),
//           Text('Daily',style: TextStyle(fontWeight: FontWeight.w500),),
//           SizedBox(height: 3.h,),
//           Text('₦$price',style: TextStyle(fontWeight: FontWeight.w500),),
//           SizedBox(height: 10.h,),
//           Text('Valid for 24 hours',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
//           Container(
//             margin: EdgeInsets.only(top: 17.h),
//             height: 29.h,
//             width: 114.w,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15)
//                   ),
//                   backgroundColor: kBlue),
//               onPressed: ()async{
//                 context.read<PassSubDetails>().saveSubType(subType);
//                 context.read<PassSubDetails>().savePassAvatarColor(Color(0xff7574A0));
//                 context.read<PassSubDetails>().savePassLogo('lib/assets/images/wynk_pass/white_wynk.png');
//                 context.read<PassSubDetails>().savePassAmount(price);
//                 context.read<PassSubDetails>().savePassDuration('24 hours');
//                 context.read<PassSubDetails>().savePassTime('Daily');
//                 context.read<PassSubDetails>().subType == 'post-paid'?
//                { Navigator.push(context, MaterialPageRoute(builder: (context)=> const PassConfirmation())),
//
//                }:
//               {  Navigator.push(context, MaterialPageRoute(builder: (context)=>  PassPurchaseConfirmPrepaid())),
//
//               };
//               },
//               child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Container BlueWynkPass (String price, BuildContext context, String subType){
//   return Container(
//     child: Container(
//       width: 144.w,
//       height: 210.h,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.black)
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 82.w,
//             height: 82.w,
//             child: CircleAvatar(
//               backgroundColor: kYellow,
//               child: Image.asset('lib/assets/images/wynk_pass/blue_wynk.png',width: 62.w,height:24.h ,),
//             ),
//           ),
//           Text('Weekly',style: TextStyle(fontWeight: FontWeight.w500),),
//           SizedBox(height: 3.h,),
//           Text('₦$price',style: TextStyle(fontWeight: FontWeight.w500),),
//           SizedBox(height: 10.h,),
//           Text('Valid for 7 days',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
//           Container(
//             margin: EdgeInsets.only(top: 17.h),
//             height: 29.h,
//             width: 114.w,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15)
//                   ),
//                   primary: kBlue),
//               onPressed: ()async{
//                 context.read<PassSubDetails>().saveSubType(subType);
//                 context.read<PassSubDetails>().savePassAvatarColor(kYellow);
//                 context.read<PassSubDetails>().savePassLogo('lib/assets/images/wynk_pass/blue_wynk.png');
//                 context.read<PassSubDetails>().savePassAmount(price);
//                 context.read<PassSubDetails>().savePassDuration('7 days');
//                 context.read<PassSubDetails>().savePassTime('Weekly');
//                 context.read<PassSubDetails>().subType == 'post-paid'?
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=> const PassConfirmation())):
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>  PassPurchaseConfirmPrepaid()));
//               },
//               child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Container YellowWynkPass (String price,BuildContext context, String subType){
//   return Container(
//     child: Container(
//       width: 144.w,
//       height: 210.h,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.black)
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 82.w,
//             height: 82.w,
//             child: CircleAvatar(
//               backgroundColor: kBlue,
//               child: Image.asset('lib/assets/images/wynk_pass/yellow_wynk.png',width: 62.w,height:24.h ,),
//             ),
//           ),
//           Text('Monthly',style: TextStyle(fontWeight: FontWeight.w500),),
//           SizedBox(height: 3.h,),
//           Text('₦$price',style: TextStyle(fontWeight: FontWeight.w500),),
//           SizedBox(height: 10.h,),
//           Text('Valid for 30 days',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp),),
//           Container(
//             margin: EdgeInsets.only(top: 17.h),
//             height: 29.h,
//             width: 114.w,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15)
//                   ),
//                   primary: kBlue),
//               onPressed: ()async{
//                 context.read<PassSubDetails>().saveSubType(subType);
//                 context.read<PassSubDetails>().savePassAvatarColor(kBlue);
//                 context.read<PassSubDetails>().savePassLogo('lib/assets/images/wynk_pass/yellow_wynk.png');
//                 context.read<PassSubDetails>().savePassAmount(price);
//                 context.read<PassSubDetails>().savePassDuration('30 days');
//                 context.read<PassSubDetails>().savePassTime('Monthly');
//                 context.read<PassSubDetails>().subType == 'post-paid'?
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=> const PassConfirmation())):
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>  PassPurchaseConfirmPrepaid()));
//               },
//               child: Text('Purchase',style: TextStyle(fontSize: 15.sp),),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }