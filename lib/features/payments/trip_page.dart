import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:wynk/controllers.dart';
import 'package:wynk/features/payments/airtime_topup.dart';
import 'package:wynk/features/payments/payment_list.dart';
import 'package:wynk/features/payments/request_funds/req_funds.dart';
import 'package:wynk/features/payments/send_funds/data_topup.dart';
import 'package:wynk/features/payments/send_funds/send_to_bank.dart';
import 'package:wynk/features/payments/send_funds/send_to_wynk.dart';
import 'package:wynk/features/payments/send_funds/sendcash.dart';
import 'package:wynk/services.dart';

import '../../../utilities/constants/colors.dart';
import '../../../utilities/widgets.dart';

class TripPage extends StatefulWidget {
  TripPage({Key? key, required this.earnings}) : super(key: key);
  List earnings;
  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String? walletName;

  @override
  Widget build(BuildContext context) {
    print(widget.earnings);
    return MaterialApp(
      home: Scaffold(
          body:
          Container(
            padding: EdgeInsets.symmetric(horizontal: 36.w,vertical: 77.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                backButton(context),
                SizedBox(height: 31.h,),
                Text('My Trips ',style: TextStyle(fontSize: 26.sp),),
                Expanded(
                  child: ListView.builder(
                      itemCount:widget.earnings.length ,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return Column(
                          children: [
                            ListTile(
                              trailing: Text('₦ ${widget.earnings[index]['amount']}'),
                              title:  Column(
                                children: [
                                  Text('From: ${widget.earnings[index]['loading']}'),
                                  Text('To: ${widget.earnings[index]['destination']}'),
                                ],
                              ),
                            ),
                            Divider(thickness: 2,)
                          ],
                        );
                      }),
                )
              ],
            ),
          )
      ),
    );
  }
}

