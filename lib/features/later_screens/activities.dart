import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../firebase/ride_schedule.dart';
class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  bool hasActivities = false;
  List<Card> bookings = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getBookings(context),
        initialData: Center(child: Column(
            mainAxisSize: MainAxisSize.min,
            children : [
              Image.asset('lib/assets/images/ridebookingempty.png'),
              Text('Nothing to show yet',style:TextStyle(fontSize: 18.sp)),
              Text('When you use our services \nyou’ll see them here',style:TextStyle(fontSize: 12.5.sp))
            ]
        )),
        builder: (
            BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasError){
            return Container(child: Text('Error'),);
          }
          if(snapshot.connectionState == ConnectionState.done){
            snapshot.data.docs.forEach((element){
              final booking = Card(
                elevation: 3,
                child: ListTile(
                  onTap: (){

                  },
                  title: Text(element['Destination']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${element['Date']} ${element['Time']}',style: TextStyle(color: Colors.black,fontSize: 16.sp),),
                      SizedBox(height: 5.h,),
                      Text('Grab Ride')
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              );
              bookings.add(booking);
            }
            );
            return  Column(
              children: [
                SizedBox(height: 30.h,),
                Expanded(
                  child: ListView(
                    children: bookings,
                  )
                )
              ],);
            // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            // print(data['nameT']);
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SizedBox(height: 30.h,),
            //     hasActivities?
            //     ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: 4,
            //         itemBuilder: (context, index){
            //           return Card(
            //             elevation: 3,
            //             child: ListTile(
            //               title: Text('Kusenla Road, Ikate Lekki'),
            //               subtitle: Text('Apr 3, 2021  11:33 AM'),
            //               isThreeLine: true,
            //               trailing: Icon(Icons.keyboard_arrow_right),
            //             ),
            //           );
            //         }):
            //     Expanded(
            //       child: Center(child:
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Image.asset('lib/assets/images/rides/nothingtodisp.png'),
            //           SizedBox(height: 23.h,),
            //           Text('Nothing to show yet',style: TextStyle(fontSize: 18.sp),),
            //           SizedBox(height: 8.h,),
            //           SizedBox(
            //               width: 144.w,
            //               child: Text('When you use our services,you’ll see them here',
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(fontSize: 13.sp,color: Colors.black12),))
            //         ],
            //       ),),
            //     )
            //   ],),
          }
       return Center(child: Column(
         mainAxisSize: MainAxisSize.min,
          children : [
            Image.asset('lib/assets/images/ridebookingempty.png'),
            Text('Nothing to show yet',style:TextStyle(fontSize: 18.sp)),
            Text('When you use our services \nyou’ll see them here',style:TextStyle(fontSize: 12.5.sp))
              ]
          ));
      },),
    );
  }
}
