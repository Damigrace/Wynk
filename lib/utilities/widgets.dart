import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/features/ride/ride_logic.dart';
import '../controllers.dart';
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

class AddTypeInputBox extends StatelessWidget {
 String? hintText;
 TextEditingController controller;
 TextInputType textInputType;
 bool? readonly;
AddTypeInputBox({Key? key,  required this.hintText,required this.controller,required this.textInputType,this.readonly}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Material(
          borderRadius: BorderRadius.circular(7),
          elevation: 3,
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
                    readOnly: readonly??true,
                    onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                    autofocus: true,
                    keyboardType:textInputType,
                    style: kTextStyle5,
                    decoration:   InputDecoration.collapsed(
                        hintText: hintText,
                        hintStyle: const TextStyle(fontSize: 15,
                            color: kBlack1
                        )),
                    controller: controller,),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white
                    ),
                    onPressed: (){}, child: const Text('Upload Image',style:TextStyle(color: Color(0xff0e0e24)) ,)),
                SizedBox(width: 10.w,)
              ],
              )
          ),
        ));
  }
}
class InputBox extends StatelessWidget {
  int? maxLine;
  String? hintText;
  TextEditingController controller;
  TextInputType textInputType;
  int? flex;
  InputBox({Key? key,  required this.hintText,required this.controller,required this.textInputType,this.flex,this.maxLine}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex??1,
        child:  Container(
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
                child: TextField(maxLines:maxLine ,
                  onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                  autofocus: true,
                  keyboardType:textInputType,
                  style: kTextStyle5,
                  decoration:   InputDecoration.collapsed(
                      hintText: hintText,
                      hintStyle: const TextStyle(fontSize: 15,
                          color: kBlack1
                      )),
                  controller: controller,),
              )
            ],
            )
        ));
  }
}
class ElevatedInputBox extends StatelessWidget {
  String? hintText;
  TextEditingController controller;
  TextInputType textInputType;
  int? flex;
  ElevatedInputBox({Key? key,  required this.hintText,required this.controller,required this.textInputType,this.flex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex??1,
        child:  Material(
          borderRadius: BorderRadius.circular(7),
          elevation: 4,
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
                    onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                    autofocus: true,
                    keyboardType:textInputType,
                    style: kTextStyle5,
                    decoration:   InputDecoration.collapsed(
                        hintText: hintText,
                        hintStyle: const TextStyle(fontSize: 15,
                            color: kBlack1
                        )),
                    controller: controller,),
                )
              ],
              )
          ),
        ));
  }
}
class readOnlyInputBox extends StatefulWidget {
  String? hintText;
  TextEditingController controller;
  TextInputType textInputType;
  readOnlyInputBox({Key? key,  required this.hintText,required this.controller,required this.textInputType}) : super(key: key);

  @override
  State<readOnlyInputBox> createState() => _readOnlyInputBoxState();
}

class _readOnlyInputBoxState extends State<readOnlyInputBox> {


  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
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
                  readOnly: true,
                  onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                  autofocus: true,
                  keyboardType:widget.textInputType,
                  style: kTextStyle5,
                  decoration:   InputDecoration.collapsed(
                      hintText: widget.hintText,
                      hintStyle: const TextStyle(fontSize: 15,
                          color: kBlack1
                      )),
                  controller: widget.controller,),
              )
            ],
            )
        ));
  }
}

class Rides extends StatefulWidget {
  String image;
  String title;
  String time;
  String price;
  Color color;
  Rides({required this.image,required this.time,required this.title,required this.price,required this.color});

  @override
  State<Rides> createState() => _RidesState();
}
int groupValue=0;
class _RidesState extends State<Rides> {

  rideChoice(String title){

    switch(title){
      case 'Economy': print(1);
      showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
          ),
          context: context,
          builder: (context){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.only(top: 33.h,left: 17.w,right: 17.w),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset('lib/assets/images/rides/handledown.png',width: 57.w,height: 12.h,),
                      SizedBox(height: 22.h,),
                      Rides(
                        image: 'lib/assets/images/rides/economy.png',
                        title: 'Economy',
                        time: '10:20 Dropoff',
                        price: '₦ 700 - 1100', color: Color(0xffF7F7F7),),
                      SizedBox(height: 21.h,),
                      Text('Select Payment Method',style: TextStyle(fontSize: 18.sp),),
                      SizedBox(
                        child: Container(
                          padding: EdgeInsets.only(top: 17.h),
                          width: double.infinity,
                          child: Row(children: [
                            Image.asset('lib/assets/images/rides/wynkvaultwallet.png',height: 26.w,width: 26.w,),
                            SizedBox(width: 18.w,),
                            SizedBox(width:260.w,child: Text('Wynk Vault',style: TextStyle(fontSize: 15.sp),)),
                            Radio<int>(value: 1, groupValue: groupValue, onChanged: (value){
                              setState(() {
                                groupValue=value!;
                              });
                            })
                          ],),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 0.h),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('lib/assets/images/rides/wynkcash.png',height: 26.w,width: 26.w,),
                            SizedBox(width: 18.w,),
                            SizedBox(width:260.w,child: Text('Cash',style: TextStyle(fontSize: 15.sp),)),
                            Radio<int>(value: 2, groupValue: 0, onChanged: (value){
                              setState(() {
                                groupValue=value!;
                              });
                            })
                          ],),
                      ),
                      SizedBox(height: 18.h,),
                    ],),),
              ],
            );
          });
      break;
    }switch(title){
      case 'Sedan': print(2);
      break;
    }switch(title){
      case 'Taxi': print(3);
      break;
    }switch(title){
      case 'Moto': print(4);
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: widget.color,
      child: Row(children: [
        Image.asset(widget.image,width: 201.w,height: 109.h,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,style: TextStyle(fontSize: 18.sp)),
            SizedBox(height: 5.h,),
            Text(widget.time,style: TextStyle(fontSize: 12.sp),),
            SizedBox(height: 13.h,),
            Text(widget.price,style: TextStyle(fontSize: 22.sp),)
          ],)
      ],),
    );
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


class DetailsTile extends StatelessWidget {

   String title;
   IconData icondata;
   TextEditingController controller;
   DetailsTile({required this.icondata,required this.title, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left:25.w,top: 26.h ,right: 24.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: kTextStyle4,),
            SizedBox(height: 7.h),
            TextField(

              enabled:  false,
              style: kTextStyle5,
              decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: EdgeInsets.only(bottom:11.h,right: 11.w),
                    height: 10.w,
                    width: 10.w,
                    padding: EdgeInsets.all(5.sp),
                    decoration: BoxDecoration(
                        color: kBlue,
                        borderRadius: BorderRadius.circular(7)
                    ),
                    child: Icon(icondata,color: Colors.white,size: 21.sp,),
                  )
              ),
              controller: controller,)
          ],),
      ),
    );
  }
}
class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 59.h,
      left: 26.w,
      child: Container(
        width: 91.w,
        height: 88.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 26.r,
              backgroundColor: Colors.red,
              child:Container(),
            ),
            Text('Captain',style: TextStyle(fontSize: 20.sp))
          ],
        ),
      ),
    );
  }
}
class ChatTile extends StatelessWidget {
  final String text;
  final Color color;
  final String time;
  const ChatTile({required this.text, Key? key, required this.color, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox
              (
              width: 36.w,height: 36.w,
              child:  CircleAvatar(
               backgroundColor: color,
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
                    padding:  EdgeInsets.only(left: 12.0.w, right: 12.0.w, top: 3,bottom: 2),
                    decoration: BoxDecoration(
                        color:Color(0xFFA2A2A2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(text,maxLines: 5,),
                  ),
                  Text(time,style: TextStyle(fontSize: 11),),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
      ],
    );
  }
}
// class StarRatingBar extends StatefulWidget {
//   late double rating;
//   StarRatingBar({required this.rating, Key? key}) : super(key: key);
//
//   @override
//   _StarRatingBarState createState() => _StarRatingBarState();
// }
//
// class _StarRatingBarState extends State<StarRatingBar> {
//   @override
//   Widget build(BuildContext context) {
//     return RatingBar.builder(
//       minRating: 1,
//       itemBuilder: (context, _) => const Icon(
//         Icons.star,
//         color: Colors.amber,
//       ),
//       updateOnDrag: true,
//       onRatingUpdate: (double rating) {
//         widget.rating = rating;
//       },
//     );
//   }
// }