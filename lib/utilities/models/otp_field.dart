import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/utilities/constants/colors.dart';

class otpField extends StatelessWidget {
  otpField({
    Key? key,required this.textEditingController
  }) : super(key: key);
  TextEditingController textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border:Border.all(color: Colors.grey,width: 2),
        color:kWhite,
      ),
      height: 61.w,width: 51.w
      ,child: Align(
      alignment: Alignment.center,
      child: TextFormField(
        decoration: const InputDecoration.collapsed(hintText: ''),
        controller:textEditingController ,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline5,
        onSaved: (onSaved){},
        onChanged: (value){
          if(value.length==1){FocusScope.of(context).nextFocus();}
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),],
      ),
    ),);
  }
}
