import 'package:flutter/material.dart';
import 'package:untitled/controllers.dart';
class Test1 extends StatefulWidget {
   Test1({Key? key}) : super(key: key);

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (val){
                  setState(() {
                    show = true;
                  });
                },
                controller: test,
              ),
              ElevatedButton(onPressed:show == false?null:(){}, child: Text('Test'))
            ],
          ),
        ),
      ),
    );
  }
}
