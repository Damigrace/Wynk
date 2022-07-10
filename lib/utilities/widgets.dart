import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/colors.dart';
import 'constants/textstyles.dart';

backButton(BuildContext context){
  return Container(height: 36.h,width: 36.h,
    decoration: BoxDecoration(
        color: kBlue,
        borderRadius: BorderRadius.circular(5)
    ),
    child: GestureDetector(
      child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 30.w,),
      onTap: ()=>Navigator.pop(context),
    ),
  );
}

class InputBox extends StatelessWidget {
 String? hintText;
 TextEditingController controller;
InputBox({Key? key,  required this.hintText,required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            height: 61.h,
            width: double.infinity,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                    color: kGrey1),
                color: kWhite),
            child:Row(children: [
              SizedBox(width: 18.w,),
              Expanded(
                child: TextField(
                  style: kTextStyle5,
                  decoration:   InputDecoration.collapsed(
                      hintText: hintText,
                      hintStyle: const TextStyle(color: kBlack1
                      )),
                  controller: controller,),
              )
            ],
            )
        ));
  }
}

class UserTopBar extends StatelessWidget {
  const UserTopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          child: ClipRect(child: Image.asset('lib/assets/images/wynkimage.png',scale: 7,)),
        ),
        title: Text('Cpt. Adeola!',style: TextStyle(fontSize: 23.sp),),
        trailing:backButton(context)
    );
  }
}
