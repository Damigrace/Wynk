import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/services.dart';
class Deliveries extends StatefulWidget {
  const Deliveries({Key? key}) : super(key: key);

  @override
  _DeliveriesState createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: determinePosition(context),
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
              return Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children : [
                    Image.asset('lib/assets/images/ridebookingempty.png'),
                    Text('Nothing to show yet',style:TextStyle(fontSize: 18.sp)),
                    Text('When you use our services \nyou’ll see them here',style:TextStyle(fontSize: 12.5.sp))
                  ]
              ));
            }
            return Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children : [
                  Image.asset('lib/assets/images/ridebookingempty.png'),
                  Text('Nothing to show yet',style:TextStyle(fontSize: 18.sp)),
                  Text('When you use our services \nyou’ll see them here',style:TextStyle(fontSize: 12.5.sp))
                ]
            ));
          },)
      ),
    );
  }
}
