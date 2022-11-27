

import 'package:flutter/material.dart';
class ThisApp extends StatefulWidget  {
   ThisApp({Key? key}) : super(key: key);

  @override
  State<ThisApp> createState() => _ThisAppState();
}

class _ThisAppState extends State<ThisApp> with SingleTickerProviderStateMixin {
  Animation? rotation;
  AnimationController? controller;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this,duration: Duration(seconds: 50));
    rotation = Tween<double>(begin: 0,end: 360).animate(controller!);
    controller?.repeat();
    controller?.addListener(() {setState(() {

    });});
  }
  @override

  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 0),(){
    });
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(child: Text('show notification'),
                onPressed: ()async{
                },),
              Transform.rotate(
                  child: Image.asset('lib/assets/images/wynk_pass/yellog.png'),
                  angle:rotation?.value)
            ],
          ),
        ),
      ),
    );
  }
}

