import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../utilities/widgets.dart';
class TransHistory extends StatefulWidget {
  TransHistory({Key? key}) : super(key: key);

  @override
  State<TransHistory> createState() => _TransHistoryState();
}

class _TransHistoryState extends State<TransHistory> {
  int? selectedV;
List things = ['1','1','1','1','1','1','1','1','1','1','1','1','1','2'];
  @override
  Widget build(BuildContext context) {

    return Scaffold(body: SingleChildScrollView(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 27.w,vertical: 41.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(context),
                SizedBox(height: 66.h,),
                Text('Transaction\nHistory',style: TextStyle(fontSize: 26.sp),),
                SizedBox(height: 30.h,),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                        ListTile.divideTiles(
                            context: context,
                            tiles: context.read<FirstData>().transcards).toList(),);

                    }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10.h,); },),

              ],
            ),
          ),

        ],),
    ),);
  }
}
